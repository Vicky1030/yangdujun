<template>
  <div class="page" v-loading="loading">
    <section class="panel hero">
      <div>
        <p class="eyebrow">自动巡检建议</p>
        <h2 class="section-title">AI 建议中心</h2>
        <p class="muted">摄像头定时抓拍并结合传感器数据自动分析异常，管理员审核后可下发给对应农户或丢弃。</p>
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
          <span>抓拍时间：{{ formatTime(item.snapshot_captured_at || item.created_at) }}</span>
          <div class="action-buttons" v-if="item.status === 'PENDING'">
            <el-button plain type="danger" @click="discardSuggestion(item)">丢弃分析</el-button>
            <el-button type="primary" @click="openDownlink(item)">下发给农户</el-button>
          </div>
        </div>
      </article>
      <el-empty v-if="!suggestions.length" description="暂无摄像头自动巡检建议" />
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { discardAiSuggestion, downlinkAiSuggestion, fetchAiSuggestions, rebuildAiKnowledge } from '../services/ai'

const loading = ref(false)
const suggestions = ref([])
const dialogVisible = ref(false)
const current = ref(null)
const downlinkNote = ref('')

const riskText = value => ({ HIGH: '高风险', MEDIUM: '中风险', LOW: '低风险' }[value] || value || '未知')
const riskType = value => ({ HIGH: 'danger', MEDIUM: 'warning', LOW: 'success' }[value] || 'info')
const statusText = value => ({ PENDING: '待审核', DOWNLINKED: '已下发', DISCARDED: '已丢弃' }[value] || value || '未知')
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

const discardSuggestion = async item => {
  await ElMessageBox.confirm(`确认丢弃“${item.title}”？丢弃后不会下发给农户。`, '丢弃 AI 分析', { type: 'warning' })
  await discardAiSuggestion(item.id, { note: '' })
  ElMessage.success('AI 分析已丢弃')
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
.action-buttons {
  display: flex;
  gap: 10px;
}
</style>
