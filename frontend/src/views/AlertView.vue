<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">告警中心</h2>
          <p class="muted">集中查看各大棚和设备发出的告警，并完成确认、处理、解决的闭环记录。</p>
        </div>
        <div class="head-actions">
          <el-select v-model="greenhouseId" clearable placeholder="全部大棚" style="width: 220px" @change="loadAlerts">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
          <el-select v-model="statusFilter" clearable placeholder="全部状态" style="width: 160px">
            <el-option label="待处理" value="OPEN" />
            <el-option label="已确认" value="ACKNOWLEDGED" />
            <el-option label="已解决" value="RESOLVED" />
          </el-select>
        </div>
      </div>

      <el-table :data="filteredAlerts" style="width: 100%; margin-top: 16px">
        <el-table-column prop="occurredAt" label="告警时间" width="180">
          <template #default="{ row }">{{ formatTime(row.occurredAt) }}</template>
        </el-table-column>
        <el-table-column prop="greenhouseName" label="发出告警的大棚" min-width="180" />
        <el-table-column prop="deviceName" label="发出告警的设备" min-width="170">
          <template #default="{ row }">{{ row.deviceName || '大棚环境监测' }}</template>
        </el-table-column>
        <el-table-column prop="title" label="告警信息" min-width="210" />
        <el-table-column prop="level" label="级别" width="100">
          <template #default="{ row }">
            <el-tag :type="levelTag(row.level)">{{ levelText(row.level) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="110">
          <template #default="{ row }">
            <el-tag :type="statusTag(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="handledBy" label="处理人" width="120">
          <template #default="{ row }">{{ row.handledBy || '-' }}</template>
        </el-table-column>
        <el-table-column prop="handledAt" label="处理时间" width="180">
          <template #default="{ row }">{{ formatTime(row.handledAt) }}</template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="240" />
        <el-table-column label="操作" width="190" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.status === 'OPEN'" link type="primary" @click="openHandle(row, 'ACKNOWLEDGED')">确认</el-button>
            <el-button v-if="row.status !== 'RESOLVED'" link type="success" @click="openHandle(row, 'RESOLVED')">解决</el-button>
            <el-button link @click="openDetail(row)">记录</el-button>
          </template>
        </el-table-column>
      </el-table>
    </section>

    <el-dialog v-model="handleDialog" :title="handleTitle" width="560px">
      <el-form label-position="top">
        <el-form-item label="告警信息">
          <div class="alert-brief">
            <strong>{{ selectedAlert?.title }}</strong>
            <span>{{ selectedAlert?.greenhouseName }} / {{ selectedAlert?.deviceName || '大棚环境监测' }}</span>
          </div>
        </el-form-item>
        <el-form-item label="处理人">
          <el-input v-model.trim="handleForm.handler" maxlength="64" />
        </el-form-item>
        <el-form-item :label="handleForm.status === 'RESOLVED' ? '处理意见（解决时必填）' : '处理意见'">
          <el-input
            v-model.trim="handleForm.note"
            type="textarea"
            :rows="4"
            maxlength="500"
            show-word-limit
            placeholder="请填写排查过程、处理措施或后续跟进说明"
          />
        </el-form-item>
        <div class="dialog-actions">
          <el-button @click="handleDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitHandle">提交</el-button>
        </div>
      </el-form>
    </el-dialog>

    <el-dialog v-model="detailDialog" title="告警处理记录" width="560px">
      <div class="detail-stack">
        <p><span>告警：</span>{{ selectedAlert?.title }}</p>
        <p><span>状态：</span>{{ statusText(selectedAlert?.status) }}</p>
        <p><span>处理人：</span>{{ selectedAlert?.handledBy || '-' }}</p>
        <p><span>处理时间：</span>{{ formatTime(selectedAlert?.handledAt) }}</p>
        <p><span>解决时间：</span>{{ formatTime(selectedAlert?.resolvedAt) }}</p>
        <p><span>处理意见：</span>{{ selectedAlert?.handleNote || '暂无处理意见' }}</p>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { fetchAlertDetails, fetchGreenhouses, handleAlert } from '../services/greenhouse'
import { useSessionStore } from '../stores/session'

const route = useRoute()
const session = useSessionStore()
const loading = ref(false)
const saving = ref(false)
const handleDialog = ref(false)
const detailDialog = ref(false)
const greenhouseId = ref(null)
const statusFilter = ref(route.query.status || '')
const greenhouses = ref([])
const alerts = ref([])
const selectedAlert = ref(null)
const handleForm = reactive({ status: 'ACKNOWLEDGED', handler: '', note: '' })

const filteredAlerts = computed(() => statusFilter.value ? alerts.value.filter(item => item.status === statusFilter.value) : alerts.value)
const handleTitle = computed(() => handleForm.status === 'RESOLVED' ? '解决告警' : '确认告警')
const levelText = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level)
const levelTag = level => level === 'CRITICAL' ? 'danger' : level === 'WARNING' ? 'warning' : 'info'
const statusText = status => ({ OPEN: '待处理', ACKNOWLEDGED: '已确认', RESOLVED: '已解决' }[status] || status || '-')
const statusTag = status => status === 'RESOLVED' ? 'success' : status === 'ACKNOWLEDGED' ? 'warning' : 'danger'
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN') : '-'

const loadAlerts = async () => {
  loading.value = true
  try {
    alerts.value = await fetchAlertDetails(greenhouseId.value)
  } finally {
    loading.value = false
  }
}

const defaultHandler = () => session.profile?.username === 'admin'
  ? '管理员'
  : (session.profile?.displayName || session.profile?.username || '管理员')

const openHandle = (row, status) => {
  selectedAlert.value = row
  Object.assign(handleForm, {
    status,
    handler: row.handledBy || defaultHandler(),
    note: row.handleNote || ''
  })
  handleDialog.value = true
}

const openDetail = (row) => {
  selectedAlert.value = row
  detailDialog.value = true
}

const submitHandle = async () => {
  if (!handleForm.handler) return ElMessage.warning('处理人不能为空')
  if (handleForm.status === 'RESOLVED' && !handleForm.note) return ElMessage.warning('解决告警时需要填写处理意见')
  saving.value = true
  try {
    await handleAlert(selectedAlert.value.id, handleForm)
    ElMessage.success(handleForm.status === 'RESOLVED' ? '告警已解决' : '告警已确认')
    handleDialog.value = false
    await loadAlerts()
  } finally {
    saving.value = false
  }
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  await loadAlerts()
})
</script>

<style scoped>
.panel-head,
.head-actions {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.alert-brief,
.detail-stack {
  display: grid;
  gap: 8px;
}

.alert-brief strong {
  color: #f6fff0;
}

.alert-brief span,
.detail-stack span {
  color: var(--muted);
}

.detail-stack p {
  margin: 0;
  line-height: 1.8;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

@media (max-width: 760px) {
  .panel-head,
  .head-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
