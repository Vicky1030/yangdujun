<template>
  <div class="page" v-loading="loading">
    <section class="panel hero">
      <div>
        <p class="eyebrow">AI 诊断建议</p>
        <h2 class="section-title">AI 建议中心</h2>
        <p class="muted">集中查看 AI 从图片诊断和环境分析中生成的风险建议，并下发给对应农户。</p>
      </div>
      <el-button type="primary" @click="rebuildKnowledge">重建知识库索引</el-button>
    </section>

    <section class="suggestion-list">
      <article v-for="item in suggestions" :key="item.id" class="panel suggestion-card">
        <div class="suggestion-title">
          <div>
            <h3>{{ item.title }}</h3>
            <p>{{ item.greenhouse_name || '未绑定大棚' }} · {{ item.farmer_username || '未绑定农户' }}</p>
          </div>
          <div class="tags">
            <el-tag :type="riskType(item.risk_level)">{{ riskText(item.risk_level) }}</el-tag>
            <el-tag>{{ statusText(item.status) }}</el-tag>
          </div>
        </div>
        <p class="content">{{ item.content }}</p>
        <div class="card-actions">
          <span>{{ formatTime(item.created_at) }}</span>
          <el-button v-if="item.status !== 'DOWNLINKED'" type="primary" @click="openDownlink(item)">下发给农户</el-button>
        </div>
      </article>
      <el-empty v-if="!suggestions.length" description="暂无 AI 建议" />
    </section>

    <el-dialog v-model="dialogVisible" title="下发 AI 建议" width="560px">
      <p class="muted">下发后会以“AI 生成建议”标记发送到农户的问题反馈会话。</p>
      <el-input v-model="downlinkNote" type="textarea" :rows="4" placeholder="管理员补充说明，可选" />
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitDownlink">确认下发</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { downlinkAiSuggestion, fetchAiSuggestions, rebuildAiKnowledge } from '../services/ai'

const loading = ref(false)
const suggestions = ref([])
const dialogVisible = ref(false)
const current = ref(null)
const downlinkNote = ref('')

const riskText = value => ({ HIGH: '高风险', MEDIUM: '中风险', LOW: '低风险' }[value] || value || '未知')
const riskType = value => ({ HIGH: 'danger', MEDIUM: 'warning', LOW: 'success' }[value] || 'info')
const statusText = value => ({ PENDING: '待下发', DOWNLINKED: '已下发' }[value] || value || '未知')
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN') : '-'

const loadSuggestions = async () => {
  loading.value = true
  try {
    suggestions.value = await fetchAiSuggestions()
  } finally {
    loading.value = false
  }
}

const rebuildKnowledge = async () => {
  loading.value = true
  try {
    const result = await rebuildAiKnowledge()
    ElMessage.success(`知识库索引完成：${result.document_count || 0} 个文档，${result.chunk_count || 0} 个片段`)
  } finally {
    loading.value = false
  }
}

const openDownlink = item => {
  current.value = item
  downlinkNote.value = ''
  dialogVisible.value = true
}

const submitDownlink = async () => {
  if (!current.value) return
  await downlinkAiSuggestion(current.value.id, { note: downlinkNote.value })
  ElMessage.success('AI 建议已下发给农户')
  dialogVisible.value = false
  await loadSuggestions()
}

onMounted(loadSuggestions)
</script>

<style scoped>
.hero,
.suggestion-title,
.card-actions {
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
.suggestion-list {
  display: grid;
  gap: 14px;
}
.suggestion-card {
  display: grid;
  gap: 14px;
}
.suggestion-title h3,
.suggestion-title p,
.content {
  margin: 0;
}
.suggestion-title h3 {
  color: var(--ink);
  font-size: 18px;
}
.suggestion-title p,
.content,
.card-actions span {
  color: var(--muted);
}
.content {
  white-space: pre-wrap;
  line-height: 1.8;
}
.tags {
  display: flex;
  gap: 8px;
}
</style>
