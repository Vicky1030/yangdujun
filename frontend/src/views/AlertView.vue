<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">告警中心</h2>
          <p class="muted">
            {{ isAdmin ? '管理员查看所有大棚告警，并通过命令处置把处理建议发送给对应农户。' : '查看自己大棚的告警，完成处理后系统会自动通知管理员。' }}
          </p>
        </div>
        <div class="head-actions">
          <el-select v-model="greenhouseId" clearable placeholder="全部大棚" style="width: 220px" @change="onFilterChange">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
          <el-select v-model="statusFilter" clearable placeholder="全部状态" style="width: 160px" @change="syncQuery">
            <el-option label="待处理" value="OPEN" />
            <el-option label="已下发建议" value="ACKNOWLEDGED" />
            <el-option label="已解决" value="RESOLVED" />
          </el-select>
        </div>
      </div>

      <div class="alert-list">
        <article v-for="alert in filteredAlerts" :key="alert.id" class="alert-card">
          <div class="alert-card__main">
            <div>
              <div class="alert-title">
                <strong>{{ cleanText(alert.title, '告警信息') }}</strong>
                <el-tag :type="levelTag(alert.level)" size="small">{{ levelText(alert.level) }}</el-tag>
                <el-tag :type="statusTag(alert.status)" size="small">{{ statusText(alert.status) }}</el-tag>
              </div>
              <p>{{ cleanText(alert.description, '暂无描述') }}</p>
            </div>
            <div class="alert-actions">
              <el-button v-if="!isAdmin && alert.status !== 'RESOLVED'" link type="success" @click="openHandle(alert)">处理完成</el-button>
              <el-button v-if="isAdmin && alert.status !== 'RESOLVED'" link type="warning" @click="openCommand(alert)">下发建议</el-button>
              <el-button link @click="openDetail(alert)">记录</el-button>
            </div>
          </div>
          <div class="alert-meta">
            <span><b>告警时间</b>{{ formatTime(alert.occurredAt) }}</span>
            <span><b>归属农户</b>{{ cleanText(alert.farmerName, '-') }}</span>
            <span><b>发出告警的大棚</b>{{ cleanText(alert.greenhouseName, '-') }}</span>
            <span><b>大棚位置</b>{{ cleanText(alert.greenhouseLocation, '-') }}</span>
            <span><b>发出告警的设备</b>{{ cleanText(alert.deviceName, '大棚环境监测') }}</span>
            <span><b>处理人</b>{{ cleanText(alert.handledBy, '-') }}</span>
            <span><b>处理时间</b>{{ formatTime(alert.handledAt) }}</span>
          </div>
        </article>
        <el-empty v-if="!filteredAlerts.length" description="当前没有符合条件的告警" />
      </div>
    </section>

    <el-dialog v-model="handleDialog" title="处理完成" width="560px">
      <el-form label-position="top">
        <el-form-item label="处理人"><el-input v-model.trim="handleForm.handler" maxlength="64" /></el-form-item>
        <el-form-item label="处理意见">
          <el-input v-model.trim="handleForm.note" type="textarea" :rows="4" maxlength="500" show-word-limit placeholder="请填写实际处理结果，提交后会自动同步给管理员。" />
        </el-form-item>
        <div class="dialog-actions">
          <el-button @click="handleDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitHandle">提交</el-button>
        </div>
      </el-form>
    </el-dialog>

    <el-dialog v-model="commandDialog" title="下发告警处置建议" width="600px">
      <el-alert
        v-if="selectedAlert"
        type="warning"
        :closable="false"
        show-icon
        class="command-alert"
        :title="`将发送给 ${cleanText(selectedAlert.farmerName, '对应农户')}：${cleanText(selectedAlert.greenhouseName, '-')}`"
      />
      <el-form label-position="top">
        <el-form-item label="关联设备">
          <el-select v-model="commandForm.deviceId" clearable style="width: 100%">
            <el-option v-for="device in commandDevices" :key="device.id" :label="cleanText(device.name, '设备')" :value="device.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="处置命令">
          <el-select v-model="commandForm.command" style="width: 100%">
            <el-option label="启动设备" value="START" />
            <el-option label="关闭设备" value="STOP" />
            <el-option label="标记维护" value="MAINTENANCE" />
          </el-select>
        </el-form-item>
        <el-form-item label="处置说明">
          <el-input v-model.trim="commandForm.note" type="textarea" :rows="4" placeholder="例如：CO₂ 浓度偏高，请检查通风策略；已准备关闭对应设备。" />
        </el-form-item>
        <el-checkbox v-model="commandForm.notifyFarmer">发送到该农户的问题反馈聊天</el-checkbox>
        <div class="dialog-actions">
          <el-button @click="commandDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitCommand">发送命令</el-button>
        </div>
      </el-form>
    </el-dialog>

    <el-dialog v-model="detailDialog" title="告警处理记录" width="560px">
      <div class="detail-stack">
        <p><span>告警：</span>{{ cleanText(selectedAlert?.title, '-') }}</p>
        <p><span>农户：</span>{{ cleanText(selectedAlert?.farmerName, '-') }}</p>
        <p><span>大棚：</span>{{ cleanText(selectedAlert?.greenhouseName, '-') }}</p>
        <p><span>位置：</span>{{ cleanText(selectedAlert?.greenhouseLocation, '-') }}</p>
        <p><span>设备：</span>{{ cleanText(selectedAlert?.deviceName, '大棚环境监测') }}</p>
        <p><span>状态：</span>{{ statusText(selectedAlert?.status) }}</p>
        <p><span>处理人：</span>{{ cleanText(selectedAlert?.handledBy, '-') }}</p>
        <p><span>处理意见：</span>{{ cleanText(selectedAlert?.handleNote, '暂无处理意见') }}</p>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { alertCommand, fetchAlertDetails, fetchDevices, fetchGreenhouses, handleAlert } from '../services/greenhouse'
import { useSessionStore } from '../stores/session'

const route = useRoute()
const router = useRouter()
const session = useSessionStore()
const isAdmin = computed(() => session.profile?.role === 'ADMIN')
const loading = ref(false)
const saving = ref(false)
const handleDialog = ref(false)
const commandDialog = ref(false)
const detailDialog = ref(false)
const greenhouseId = ref(route.query.greenhouseId ? Number(route.query.greenhouseId) : null)
const statusFilter = ref(route.query.status || '')
const greenhouses = ref([])
const alerts = ref([])
const selectedAlert = ref(null)
const commandDevices = ref([])
const handleForm = reactive({ status: 'RESOLVED', handler: '', note: '' })
const commandForm = reactive({ deviceId: null, command: 'STOP', note: '', notifyFarmer: true })

const filteredAlerts = computed(() => statusFilter.value ? alerts.value.filter(item => item.status === statusFilter.value) : alerts.value)
const levelText = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level || '-')
const levelTag = level => level === 'CRITICAL' ? 'danger' : level === 'WARNING' ? 'warning' : 'info'
const statusText = status => ({ OPEN: '待处理', ACKNOWLEDGED: '已下发建议', RESOLVED: '农户已解决' }[status] || status || '-')
const statusTag = status => status === 'RESOLVED' ? 'success' : status === 'ACKNOWLEDGED' ? 'warning' : 'danger'
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN') : '-'
const cleanText = (value, fallback) => {
  if (value == null || String(value).trim() === '') return fallback
  const text = String(value)
  if (text.includes('????')) return fallback
  return text.replace(/CO2/g, 'CO₂')
}

const syncQuery = () => {
  router.replace({
    path: '/alerts',
    query: {
      ...(route.query.farmerId ? { farmerId: route.query.farmerId } : {}),
      ...(greenhouseId.value ? { greenhouseId: greenhouseId.value } : {}),
      ...(statusFilter.value ? { status: statusFilter.value } : {})
    }
  })
}

const loadAlerts = async () => {
  loading.value = true
  try {
    alerts.value = await fetchAlertDetails(greenhouseId.value)
  } finally {
    loading.value = false
  }
}

const onFilterChange = async () => {
  syncQuery()
  await loadAlerts()
}

const defaultHandler = () => session.profile?.username || (isAdmin.value ? '管理员' : '农户')
const openHandle = row => {
  selectedAlert.value = row
  Object.assign(handleForm, { status: 'RESOLVED', handler: row.handledBy || defaultHandler(), note: row.handleNote || '' })
  handleDialog.value = true
}
const openDetail = row => { selectedAlert.value = row; detailDialog.value = true }

const openCommand = async row => {
  selectedAlert.value = row
  commandDevices.value = await fetchDevices(row.greenhouseId)
  Object.assign(commandForm, { deviceId: row.deviceId || null, command: 'STOP', note: '', notifyFarmer: true })
  commandDialog.value = true
}

const submitHandle = async () => {
  if (!handleForm.handler) return ElMessage.warning('处理人不能为空')
  if (!handleForm.note) return ElMessage.warning('请填写处理意见')
  saving.value = true
  try {
    await handleAlert(selectedAlert.value.id, handleForm)
    ElMessage.success('告警已解决，处理结果已同步给管理员')
    handleDialog.value = false
    await loadAlerts()
  } finally {
    saving.value = false
  }
}

const submitCommand = async () => {
  if (!commandForm.command) return ElMessage.warning('请选择处置命令')
  saving.value = true
  try {
    await alertCommand(selectedAlert.value.id, commandForm)
    ElMessage.success('处置建议已记录，并发送给对应农户')
    commandDialog.value = false
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
.panel-head, .head-actions { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
.head-actions { flex-wrap: wrap; justify-content: flex-end; }
.alert-list { display: grid; gap: 12px; margin-top: 18px; }
.alert-card { padding: 16px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255,255,255,.82); box-shadow: 0 10px 26px rgba(39, 80, 47, .06); }
.alert-card__main { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 16px; }
.alert-title { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
.alert-title strong { color: var(--ink); font-size: 16px; }
.alert-card p { margin: 8px 0 0; color: var(--muted); line-height: 1.7; }
.alert-actions { display: flex; flex-wrap: wrap; gap: 8px; align-items: flex-start; white-space: nowrap; }
.alert-actions :deep(.el-button + .el-button) { margin-left: 0; }
.alert-meta { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 10px; margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--line); }
.alert-meta span { min-width: 0; color: var(--ink); font-size: 13px; line-height: 1.5; word-break: break-word; }
.alert-meta b { display: block; margin-bottom: 4px; color: var(--muted); font-weight: 700; }
.command-alert { margin-bottom: 14px; }
.detail-stack { display: grid; gap: 8px; }
.detail-stack span { color: var(--muted); }
.detail-stack p { margin: 0; line-height: 1.8; }
.dialog-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px; }
</style>
