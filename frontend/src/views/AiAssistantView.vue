<template>
  <div class="page ai-page">
    <section class="panel hero">
      <div>
        <p class="eyebrow">本地多模态 RAG</p>
        <h2 class="section-title">羊肚菌专业 AI 助手</h2>
        <p class="muted">结合知识库、图像识别和大棚环境数据，辅助判断长势、病虫害风险与调控建议。</p>
      </div>
      <el-select v-model="greenhouseId" placeholder="选择大棚" style="width: 260px" clearable>
        <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
    </section>

    <section class="assistant-grid">
      <div class="panel chat-panel">
        <div class="panel-head">
          <h3>对话问答</h3>
          <span>文本问答专家 · 知识库检索专家</span>
        </div>
        <div class="messages">
          <article v-for="item in messages" :key="item.id" :class="['message', item.role]">
            <strong>{{ item.role === 'user' ? '我' : 'AI 助手' }}</strong>
            <p>{{ item.content }}</p>
          </article>
          <article v-if="chatLoading" class="message assistant">
            <strong>AI 助手</strong>
            <p>正在调用本地模型，请稍候...</p>
          </article>
          <el-empty v-if="!messages.length" description="可以询问出菇管理、环境调控、病虫害预防等问题" />
        </div>
        <div class="composer">
          <el-input
            v-model="question"
            type="textarea"
            :rows="3"
            placeholder="例如：当前湿度偏高时，羊肚菌出菇期应该怎么处理？"
          />
          <el-button type="primary" :loading="chatLoading" :disabled="!question.trim()" @click="sendChat">发送</el-button>
        </div>
      </div>

      <div class="panel diagnosis-panel">
        <div class="panel-head">
          <h3>图片诊断</h3>
          <span>图像识别专家 · 建议生成专家</span>
        </div>
        <label class="upload-box">
          <input type="file" accept="image/*" @change="pickImage" />
          <img v-if="imagePreview" :src="imagePreview" alt="待诊断图片" />
          <span v-else>上传羊肚菌照片</span>
        </label>
        <el-input v-model="diagnosisQuestion" placeholder="补充说明，可选" />
        <el-button type="primary" :loading="diagnosisLoading" :disabled="!imageBase64" @click="sendDiagnosis">开始诊断</el-button>

        <div v-if="lastResult" class="result-card">
          <div class="risk-line">
            <strong>风险等级</strong>
            <el-tag :type="riskType(lastResult.risk_level)">{{ riskText(lastResult.risk_level) }}</el-tag>
          </div>
          <p>{{ lastResult.answer }}</p>
          <div v-if="lastResult.actions?.length" class="actions">
            <strong>建议操作</strong>
            <ul>
              <li v-for="action in lastResult.actions" :key="action">{{ action }}</li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <section v-if="lastResult?.references?.length" class="panel">
      <div class="panel-head">
        <h3>知识库依据</h3>
        <span>RAG 检索结果</span>
      </div>
      <div class="reference-list">
        <article v-for="ref in lastResult.references" :key="`${ref.source}-${ref.page}-${ref.content}`">
          <strong>{{ ref.source }} <span v-if="ref.page">第 {{ ref.page }} 页</span></strong>
          <p>{{ ref.content }}</p>
        </article>
      </div>
    </section>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { chatWithAi, diagnoseImage } from '../services/ai'
import { fetchGreenhouses } from '../services/greenhouse'

const chatLoading = ref(false)
const diagnosisLoading = ref(false)
const greenhouses = ref([])
const greenhouseId = ref(null)
const question = ref('')
const diagnosisQuestion = ref('')
const messages = ref([])
const lastResult = ref(null)
const imageBase64 = ref('')
const imagePreview = ref('')
const imageFilename = ref('')

const riskText = value => ({ HIGH: '高风险', MEDIUM: '中风险', LOW: '低风险' }[value] || value || '未知')
const riskType = value => ({ HIGH: 'danger', MEDIUM: 'warning', LOW: 'success' }[value] || 'info')

const sendChat = async () => {
  const text = question.value.trim()
  if (!text) return
  const id = Date.now()
  messages.value.push({ id, role: 'user', content: text })
  question.value = ''
  chatLoading.value = true
  try {
    const result = await chatWithAi({ question: text, greenhouseId: greenhouseId.value })
    lastResult.value = result
    messages.value.push({ id: id + 1, role: 'assistant', content: result.answer || 'AI 暂未返回回答' })
  } catch (error) {
    messages.value.push({ id: id + 1, role: 'assistant', content: error.message || 'AI 服务暂时不可用，请稍后重试' })
  } finally {
    chatLoading.value = false
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

const sendDiagnosis = async () => {
  if (!imageBase64.value) return
  diagnosisLoading.value = true
  try {
    const result = await diagnoseImage({
      question: diagnosisQuestion.value,
      greenhouseId: greenhouseId.value,
      imageBase64: imageBase64.value,
      imageFilename: imageFilename.value
    })
    lastResult.value = result
    messages.value.push({ id: Date.now(), role: 'assistant', content: result.answer || '图片诊断完成' })
  } catch (error) {
    messages.value.push({ id: Date.now(), role: 'assistant', content: error.message || '图片诊断暂时不可用，请稍后重试' })
  } finally {
    diagnosisLoading.value = false
  }
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  greenhouseId.value = greenhouses.value[0]?.id || null
})
</script>

<style scoped>
.ai-page { gap: 18px; }
.hero,
.panel-head,
.composer,
.risk-line {
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
  display: grid;
  grid-template-columns: minmax(0, 1.25fr) minmax(360px, .75fr);
  gap: 18px;
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
.chat-panel,
.diagnosis-panel {
  display: grid;
  gap: 16px;
}
.messages {
  display: grid;
  align-content: start;
  min-height: 360px;
  max-height: 520px;
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
.composer :deep(.el-textarea) {
  flex: 1;
}
.upload-box {
  position: relative;
  display: grid;
  height: 260px;
  place-items: center;
  overflow: hidden;
  border: 1px dashed rgba(83, 184, 106, .55);
  border-radius: var(--radius);
  background: rgba(83, 184, 106, .08);
  color: var(--brand-strong);
  font-weight: 900;
  cursor: pointer;
}
.upload-box input {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}
.upload-box img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.result-card {
  display: grid;
  gap: 12px;
  padding: 14px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.76);
}
.result-card p {
  margin: 0;
  line-height: 1.8;
  white-space: pre-wrap;
}
.actions ul {
  margin: 8px 0 0;
  padding-left: 20px;
  color: var(--muted);
}
.reference-list {
  display: grid;
  gap: 12px;
}
.reference-list article {
  padding: 12px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.72);
}
.reference-list p {
  margin: 6px 0 0;
  color: var(--muted);
  line-height: 1.7;
}
@media (max-width: 1080px) {
  .assistant-grid {
    grid-template-columns: 1fr;
  }
}
</style>
