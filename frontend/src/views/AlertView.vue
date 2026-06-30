<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">告警中心</h2>
          <p class="muted">集中查看各大棚和设备发出的告警，管理员和对应农户都可以完成确认、处理、解决的闭环记录。</p>
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

      <div class="alert-list">
        <article v-for="alert in filteredAlerts" :key="alert.id" class="alert-card">
          <div class="alert-card__main">
            <div>
              <div class="alert-title">
                <strong>{{ alert.title }}</strong>
                <el-tag :type="levelTag(alert.level)" size="small">{{ levelText(alert.level) }}</el-tag>
                <el-tag :type="statusTag(alert.status)" size="small">{{ statusText(alert.status) }}</el-tag>
              </div>
              <p>{{ alert.description || '暂无描述' }}</p>
            </div>
            <div class="alert-actions">
              <el-button v-if="alert.status === 'OPEN'" link type="primary" @click="openHandle(alert, 'ACKNOWLEDGED')">确认</el-button>
              <el-button v-if="alert.status !== 'RESOLVED'" link type="success" @click="openHandle(alert, 'RESOLVED')">解决</el-button>
              <el-button v-if="isAdmin" link type="warning" @click="openCommand(alert)">命令处置</el-button>
              <el-button link @click="openDetail(alert)">记录</el-button>
            </div>
          </div>
          <div class="alert-meta">
            <span><b>告警时间</b>{{ formatTime(alert.occurredAt) }}</span>
            <span><b>发出告警的大棚</b>{{ alert.greenhouseName || '-' }}</span>
            <span><b>发出告警的设备</b>{{ alert.deviceName || '大棚环境监测' }}</span>
            <span><b>处理人</b>{{ alert.handledBy || '-' }}</span>
            <span><b>处理时间</b>{{ formatTime(alert.handledAt) }}</span>
          </div>
        </article>
        <el-empty v-if="!filteredAlerts.length" description="当前没有符合条件的告警" />
      </div>
    </section>

    <el-dialog v-model="handleDialog" :title="handleTitle" width="560px">
      <el-form label-position="top">
        <el-form-item label="处理人"><el-input v-model.trim="handleForm.handler" maxlength="64" /></el-form-item>
        <el-form-item :label="handleForm.status === 'RESOLVED' ? '处理意见（解决时必填）' : '处理意见'">
          <el-input v-model.trim="handleForm.note" type="textarea" :rows="4" maxlength="500" show-word-limit />
        </el-form-item>
        <div class="dialog-actions">
          <el-button @click="handleDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitHandle">提交</el-button>
        </div>
      </el-form>
    </el-dialog>

    <el-dialog v-model="commandDialog" title="告警命令处置" width="580px">
      <el-form label-position="top">
        <el-form-item label="关联设备">
          <el-select v-model="commandForm.deviceId" clearable style="width: 100%">
            <el-option v-for="device in commandDevices" :key="device.id" :label="device.name" :value="device.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="下发命令">
          <el-select v-model="commandForm.command" style="width: 100%">
            <el-option label="启动设备" value="START" />
            <el-option label="关闭设备" value="STOP" />
            <el-option label="标记维护" value="MAINTENANCE" />
          </el-select>
        </el-form-item>
        <el-form-item label="处置说明">
          <el-input v-model.trim="commandForm.note" type="textarea" :rows="4" placeholder="例如：过热告警，已关闭循环风机并通知农户检查线路。" />
        </el-form-item>
        <el-checkbox v-model="commandForm.notifyFarmer">通知该大棚农户</el-checkbox>
        <div class="dialog-actions">
          <el-button @click="commandDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitCommand">下发并记录</el-button>
        </div>
      </el-form>
    </el-dialog>

    <el-dialog v-model="detailDialog" title="告警处理记录" width="560px">
      <div class="detail-stack">
        <p><span>告警：</span>{{ selectedAlert?.title }}</p>
        <p><span>大棚：</span>{{ selectedAlert?.greenhouseName || '-' }}</p>
        <p><span>设备：</span>{{ selectedAlert?.deviceName || '大棚环境监测' }}</p>
        <p><span>状态：</span>{{ statusText(selectedAlert?.status) }}</p>
        <p><span>处理人：</span>{{ selectedAlert?.handledBy || '-' }}</p>
        <p><span>处理意见：</span>{{ selectedAlert?.handleNote || '暂无处理意见' }}</p>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { alertCommand, fetchAlertDetails, fetchDevices, fetchGreenhouses, handleAlert } from '../services/greenhouse'
import { useSessionStore } from '../stores/session'

const route = useRoute()
const session = useSessionStore()
const isAdmin = computed(() => session.profile?.role === 'ADMIN')
const loading = ref(false)
const saving = ref(false)
const handleDialog = ref(false)
const commandDialog = ref(false)
const detailDialog = ref(false)
const greenhouseId = ref(null)
const statusFilter = ref(route.query.status || '')
const greenhouses = ref([])
const alerts = ref([])
const selectedAlert = ref(null)
const commandDevices = ref([])
const handleForm = reactive({ status: 'ACKNOWLEDGED', handler: '', note: '' })
const commandForm = reactive({ deviceId: null, command: 'STOP', note: '', notifyFarmer: true })

const filteredAlerts = computed(() => statusFilter.value ? alerts.value.filter(item => item.status === statusFilter.value) : alerts.value)
const handleTitle = computed(() => handleForm.status === 'RESOLVED' ? '解决告警' : '确认告警')
const levelText = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level)
const levelTag = level => level === 'CRITICAL' ? 'danger' : level === 'WARNING' ? 'warning' : 'info'
const statusText = status => ({ OPEN: '待处理', ACKNOWLEDGED: '已确认', RESOLVED: '已解决' }[status] || status || '-')
const statusTag = status => status === 'RESOLVED' ? 'success' : status === 'ACKNOWLEDGED' ? 'warning' : 'danger'
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN') : '-'

const loadAlerts = async () => {
  loading.value = true
  try { alerts.value = await fetchAlertDetails(greenhouseId.value) } finally { loading.value = false }
}

const defaultHandler = () => session.profile?.username || (isAdmin.value ? '管理员' : '农户')
const openHandle = (row, status) => { selectedAlert.value = row; Object.assign(handleForm, { status, handler: row.handledBy || defaultHandler(), note: row.handleNote || '' }); handleDialog.value = true }
const openDetail = row => { selectedAlert.value = row; detailDialog.value = true }

const openCommand = async row => {
  selectedAlert.value = row
  commandDevices.value = await fetchDevices(row.greenhouseId)
  Object.assign(commandForm, { deviceId: row.deviceId || null, command: 'STOP', note: '', notifyFarmer: true })
  commandDialog.value = true
}

const submitHandle = async () => {
  if (!handleForm.handler) return ElMessage.warning('处理人不能为空')
  if (handleForm.status === 'RESOLVED' && !handleForm.note) return ElMessage.warning('解决告警时需要填写处理意见')
  saving.value = true
  try {
    await handleAlert(selectedAlert.value.id, handleForm)
    ElMessage.success('告警状态已更新')
    handleDialog.value = false
    await loadAlerts()
  } finally { saving.value = false }
}

const submitCommand = async () => {
  if (!commandForm.command) return ElMessage.warning('请选择下发命令')
  saving.value = true
  try {
    await alertCommand(selectedAlert.value.id, commandForm)
    ElMessage.success('命令已下发并记录')
    commandDialog.value = false
    await loadAlerts()
  } finally { saving.value = false }
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  await loadAlerts()
})
</script>

<style scoped>
.panel-head, .head-actions { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
.head-actions { flex-wrap: wrap; justify-content: flex-end; }
.alert-list { display: grid; gap: 12px; margin-top: 18px; }
.alert-card { padding: 16px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255,255,255,.72); }
.alert-card__main { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 16px; }
.alert-title { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
.alert-title strong { color: var(--ink); font-size: 16px; }
.alert-card p { margin: 8px 0 0; color: var(--muted); line-height: 1.7; }
.alert-actions { display: flex; flex-wrap: wrap; gap: 8px; align-items: flex-start; white-space: nowrap; }
.alert-actions :deep(.el-button + .el-button) { margin-left: 0; }
.alert-meta { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--line); }
.alert-meta span { min-width: 0; color: var(--ink); font-size: 13px; line-height: 1.5; word-break: break-word; }
.alert-meta b { display: block; margin-bottom: 4px; color: var(--muted); font-weight: 700; }
.detail-stack { display: grid; gap: 8px; }
.detail-stack span { color: var(--muted); }
.detail-stack p { margin: 0; line-height: 1.8; }
.dialog-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px; }
</style>
