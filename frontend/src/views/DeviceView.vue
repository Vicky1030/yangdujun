<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">设备管理</h2>
          <p class="muted">按大棚查看风机、水泵、补光灯、传感器等设备，新增设备时必须绑定到具体大棚。</p>
        </div>
        <div class="head-actions">
          <el-select v-model="greenhouseId" style="width: 260px" @change="loadDevices">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
          <el-button type="primary" @click="deviceDialog = true">添加设备</el-button>
        </div>
      </div>

      <div class="device-grid">
        <article v-for="device in devices" :key="device.id" class="device-card" :class="device.status.toLowerCase()">
          <div class="device-card__top">
            <span>{{ categoryText(device.category) }}</span>
            <el-tag :type="statusTag(device.status)">{{ statusText(device.status) }}</el-tag>
          </div>
          <h3>{{ device.name }}</h3>
          <p>{{ device.location || '未填写安装位置' }}</p>
          <el-progress :percentage="device.healthScore" :stroke-width="10" />
          <div class="device-card__actions">
            <el-button size="small" type="primary" @click="command(device, 'START')">启动</el-button>
            <el-button size="small" @click="command(device, 'STOP')">停止</el-button>
          </div>
        </article>
        <el-empty v-if="!devices.length" description="当前大棚暂无设备" />
      </div>
    </section>

    <el-dialog v-model="deviceDialog" title="添加设备" width="560px">
      <el-form label-position="top">
        <el-form-item label="绑定大棚">
          <el-select v-model="deviceForm.greenhouseId" style="width: 100%">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="设备名称"><el-input v-model.trim="deviceForm.name" /></el-form-item>
        <el-form-item label="设备类型">
          <el-select v-model="deviceForm.category" style="width: 100%" allow-create filterable>
            <el-option label="通风" value="通风" />
            <el-option label="加湿" value="加湿" />
            <el-option label="补光" value="补光" />
            <el-option label="CO2 调控" value="二氧化碳" />
            <el-option label="灌溉" value="灌溉" />
          </el-select>
        </el-form-item>
        <el-form-item label="安装位置"><el-input v-model.trim="deviceForm.location" /></el-form-item>
        <el-form-item label="自动模式"><el-switch v-model="deviceForm.autoMode" /></el-form-item>
        <el-button type="primary" :loading="saving" @click="submitDevice">确认添加</el-button>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createDevice, fetchDevices, fetchGreenhouses, sendDeviceCommand } from '../services/greenhouse'

const loading = ref(false)
const saving = ref(false)
const deviceDialog = ref(false)
const greenhouses = ref([])
const greenhouseId = ref(null)
const devices = ref([])
const deviceForm = reactive({ greenhouseId: null, name: '', category: '', location: '', autoMode: true })

const statusText = status => ({ RUNNING: '运行中', STOPPED: '已停止', MAINTENANCE: '维护中' }[status] || status)
const statusTag = status => status === 'RUNNING' ? 'success' : status === 'MAINTENANCE' ? 'warning' : 'info'
const categoryText = category => category || '智能设备'

const loadGreenhouses = async () => {
  greenhouses.value = await fetchGreenhouses()
  greenhouseId.value = greenhouseId.value || greenhouses.value[0]?.id
  deviceForm.greenhouseId = deviceForm.greenhouseId || greenhouseId.value
}

const loadDevices = async () => {
  if (!greenhouseId.value) return
  loading.value = true
  try {
    devices.value = await fetchDevices(greenhouseId.value)
    deviceForm.greenhouseId = greenhouseId.value
  } finally {
    loading.value = false
  }
}

const submitDevice = async () => {
  if (!deviceForm.greenhouseId) return ElMessage.warning('请选择绑定大棚')
  if (!deviceForm.name) return ElMessage.warning('请填写设备名称')
  if (!deviceForm.category) return ElMessage.warning('请选择设备类型')
  saving.value = true
  try {
    await createDevice(deviceForm)
    ElMessage.success('设备已添加')
    deviceDialog.value = false
    greenhouseId.value = deviceForm.greenhouseId
    Object.assign(deviceForm, { greenhouseId: greenhouseId.value, name: '', category: '', location: '', autoMode: true })
    await loadDevices()
  } finally {
    saving.value = false
  }
}

const command = async (device, action) => {
  await sendDeviceCommand({ deviceId: device.id, command: action, value: '' })
  ElMessage.success(`${device.name} ${action === 'START' ? '启动' : '停止'}指令已下发`)
  await loadDevices()
}

onMounted(async () => {
  await loadGreenhouses()
  await loadDevices()
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

.device-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 16px;
  margin-top: 18px;
}

.device-card {
  padding: 16px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255, 255, 255, 0.055);
  transition: transform 220ms ease, border-color 220ms ease;
}

.device-card:hover {
  transform: translateY(-3px);
  border-color: rgba(54, 230, 166, 0.48);
}

.device-card.running {
  box-shadow: inset 0 0 0 1px rgba(54, 230, 166, 0.18), 0 0 24px rgba(54, 230, 166, 0.1);
}

.device-card__top,
.device-card__actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.device-card h3 {
  margin: 16px 0 6px;
  color: #f7fffb;
}

.device-card p {
  margin: 0 0 14px;
  color: var(--muted);
}

.device-card__actions {
  margin-top: 14px;
  justify-content: flex-start;
}

@media (max-width: 760px) {
  .panel-head,
  .head-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
