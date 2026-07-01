<template>
  <div class="page ai-page">
    <section class="panel hero">
      <div>
        <p class="eyebrow">本地多模态 RAG</p>
        <h2 class="section-title">羊肚菌专业 AI 助手</h2>
        <p class="muted">结合知识库、图像识别和大棚环境数据，辅助判断长势、病虫害风险与调控建议。</p>
      </div>
      <el-select v-model="greenhouseId" placeholder="可选：关联大棚环境" style="width: 260px" clearable>
        <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
    </section>

    <section class="assistant-grid">
      <div class="panel chat-panel">
        <div class="panel-head">
          <h3>对话问答</h3>
          <div class="panel-actions">
            <span>文本问答专家 · 图像识别专家 · 知识库检索专家</span>
            <el-button
              v-if="isAdmin"
              size="small"
              type="primary"
              plain
              :loading="downlinking"
              :disabled="!canDownlink"
              @click="downlinkCurrentAnswer"
            >
              下发当前建议
            </el-button>
          </div>
        </div>
        <div class="messages">
          <article v-for="item in messages" :key="item.id" :class="['message', item.role]">
            <strong>{{ item.role === 'user' ? '我' : 'AI 助手' }}</strong>
            <img v-if="item.image" class="message-image" :src="item.image" alt="上传图片" />
            <p>{{ item.content }}</p>
          </article>
          <article v-if="chatLoading" class="message assistant">
            <strong>AI 助手</strong>
            <p>正在调用本地模型，请稍候...</p>
          </article>
          <el-empty v-if="!messages.length" description="可以询问出菇管理、环境调控、病虫害预防等问题" />
        </div>
        <div class="composer">
          <input ref="fileInput" class="file-input" type="file" accept="image/*" @change="pickImage" />
          <el-button class="upload-action" :plain="!imageBase64" type="success" @click="fileInput?.click()">
            {{ imageBase64 ? '已选择图片' : '上传图片' }}
          </el-button>
          <el-input
            v-model="question"
            type="textarea"
            :rows="3"
            :placeholder="imageBase64 ? '可补充图片说明，也可以直接发送诊断' : '例如：当前湿度偏高时，羊肚菌出菇期应该怎么处理？'"
          />
          <el-button type="primary" :loading="chatLoading" :disabled="!question.trim() && !imageBase64" @click="sendChat">发送</el-button>
        </div>
        <div v-if="imagePreview" class="image-preview-chip">
          <img :src="imagePreview" alt="已选择图片" />
          <span>{{ imageFilename }}</span>
          <el-button text type="danger" @click="clearImage">移除</el-button>
        </div>
      </div>
    </section>

  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { chatWithAi, diagnoseImage, directDownlinkAiSuggestion } from '../services/ai'
import { fetchGreenhouses } from '../services/greenhouse'
import { useSessionStore } from '../stores/session'

const session = useSessionStore()
const chatLoading = ref(false)
const downlinking = ref(false)
const greenhouses = ref([])
const greenhouseId = ref(null)
const question = ref('')
const messages = ref([])
const lastResult = ref(null)
const imageBase64 = ref('')
const imagePreview = ref('')
const imageFilename = ref('')
const fileInput = ref(null)
const lastPrompt = ref('')
const isAdmin = computed(() => session.profile?.role === 'ADMIN')
const canDownlink = computed(() => isAdmin.value && lastResult.value?.answer && greenhouseId.value)

const sendChat = async () => {
  const hasImage = Boolean(imageBase64.value)
  const text = question.value.trim()
  if (!text && !hasImage) return
  const id = Date.now()
  const userText = text || '请分析这张羊肚菌图片'
  lastPrompt.value = userText
  const selectedImage = imageBase64.value
  const selectedFilename = imageFilename.value
  messages.value.push({ id, role: 'user', content: userText, image: imagePreview.value })
  question.value = ''
  clearImage()
  chatLoading.value = true
  try {
    const result = hasImage
      ? await diagnoseImage({
          question: userText,
          greenhouseId: greenhouseId.value,
          imageBase64: selectedImage,
          imageFilename: selectedFilename
        })
      : await chatWithAi({ question: userText, greenhouseId: greenhouseId.value })
    lastResult.value = result
    messages.value.push({ id: id + 1, role: 'assistant', content: result.answer || 'AI 暂未返回回答' })
  } catch (error) {
    messages.value.push({ id: id + 1, role: 'assistant', content: error.message || 'AI 服务暂时不可用，请稍后重试' })
  } finally {
    chatLoading.value = false
  }
}

const downlinkCurrentAnswer = async () => {
  if (!canDownlink.value) return
  downlinking.value = true
  try {
    await directDownlinkAiSuggestion({
      greenhouseId: greenhouseId.value,
      title: lastPrompt.value || 'AI 对话建议',
      content: lastResult.value.answer,
      riskLevel: lastResult.value.risk_level || 'LOW'
    })
    ElMessage.success('AI 建议已下发给该大棚绑定农户')
  } finally {
    downlinking.value = false
  }
}

const pickImage = event => {
  const file = event.target.files?.[0]
  if (!file) return
  imageFilename.value = file.name
  const reader = new FileReader()
  reader.onload = () => {
    imageBase64.value = String(reader.result || '')
    imagePreview.value = imageBase64.value
  }
  reader.onerror = () => ElMessage.error('图片读取失败')
  reader.readAsDataURL(file)
}

const clearImage = () => {
  imageBase64.value = ''
  imagePreview.value = ''
  imageFilename.value = ''
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  greenhouseId.value = null
})
</script>

<style scoped>
.ai-page {
  height: calc(100vh - 132px);
  min-height: 620px;
  gap: 14px;
  overflow: hidden;
}
.hero,
.panel-head,
.composer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}
.eyebrow {
  margin: 0 0 8px;
  color: var(--brand-strong);
  font-weight: 900;
}
.assistant-grid {
  display: block;
}
.panel-head h3,
.panel-head span {
  margin: 0;
}
.panel-head h3 {
  color: var(--ink);
  font-size: 18px;
}
.panel-head span {
  color: var(--muted);
  font-size: 13px;
  font-weight: 800;
}
.panel-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
}
.chat-panel {
  display: grid;
  gap: 16px;
  grid-template-rows: auto minmax(0, 1fr) auto;
  height: calc(100vh - 270px);
  min-height: 430px;
}
.messages {
  display: grid;
  align-content: start;
  min-height: 0;
  overflow: auto;
  gap: 12px;
  padding: 8px;
}
.message {
  width: fit-content;
  max-width: 78%;
  padding: 12px 14px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.86);
}
.message.user {
  justify-self: end;
  background: rgba(83, 184, 106, .13);
}
.message strong,
.message p {
  margin: 0;
}
.message p {
  margin-top: 6px;
  white-space: pre-wrap;
  line-height: 1.75;
}
.message-image {
  display: block;
  width: min(280px, 100%);
  max-height: 210px;
  margin-top: 10px;
  border: 1px solid var(--line);
  border-radius: 8px;
  object-fit: cover;
}
.file-input {
  display: none;
}
.upload-action {
  align-self: stretch;
  min-width: 96px;
}
.composer :deep(.el-textarea) {
  flex: 1;
}
.image-preview-chip {
  display: flex;
  align-items: center;
  width: fit-content;
  max-width: 100%;
  gap: 10px;
  padding: 8px 10px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.76);
}
.image-preview-chip img {
  width: 42px;
  height: 42px;
  border-radius: 8px;
  object-fit: cover;
}
.image-preview-chip span {
  max-width: 280px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: var(--muted);
}
@media (max-width: 1080px) {
  .ai-page {
    height: auto;
    overflow: visible;
  }
  .chat-panel {
    height: min(680px, calc(100vh - 180px));
  }
  .panel-actions {
    align-items: flex-start;
    flex-direction: column;
  }
  .composer {
    align-items: stretch;
    flex-direction: column;
  }
  .upload-action {
    width: 100%;
  }
}
</style>
