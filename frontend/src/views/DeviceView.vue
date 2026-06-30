<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">设备管理</h2>
          <p class="muted">{{ isAdmin ? '管理员可按农户和大棚查看设备档案，设备新增、编辑和删除由农户完成。' : '管理自己绑定大棚中的设备，可新增、编辑和删除设备档案。' }}</p>
        </div>
        <div class="head-actions">
          <el-select v-if="isAdmin" v-model="farmerId" clearable placeholder="选择农户" style="width: 220px" @change="onFarmerChange">
            <el-option v-for="item in farmers" :key="item.id" :label="userLabel(item)" :value="item.id" />
          </el-select>
          <el-select v-model="greenhouseId" placeholder="选择大棚" style="width: 250px" @change="loadDevices">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
          <el-button v-if="!isAdmin" type="primary" :disabled="!greenhouseId" @click="openCreate">添加设备</el-button>
        </div>
      </div>

      <div class="device-grid">
        <article v-for="device in visibleDevices" :key="device.id" class="device-card">
          <div class="device-card__top">
            <span>{{ displayText(device.category, '智能设备') }}</span>
            <el-tag :type="statusTag(device.status)">{{ statusText(device.status) }}</el-tag>
          </div>
          <h3>{{ displayText(device.name, '设备信息待核验') }}</h3>
          <p>{{ displayText(device.location, '未填写安装位置') }}</p>
          <p v-if="device.remark" class="remark">{{ displayText(device.remark, '') }}</p>
          <el-progress :percentage="device.healthScore" :stroke-width="10" :status="device.healthScore < 60 ? 'exception' : undefined" />
          <div v-if="!isAdmin" class="device-card__actions">
            <el-button size="small" @click="openEdit(device)">编辑</el-button>
            <el-button size="small" type="danger" plain @click="removeDevice(device)">删除</el-button>
          </div>
        </article>
        <el-empty v-if="!visibleDevices.length" description="当前大棚暂无设备" />
      </div>
    </section>

    <el-dialog v-model="deviceDialog" :title="editingId ? '编辑设备' : '添加设备'" width="580px">
      <el-form label-position="top">
        <el-form-item label="绑定大棚">
          <el-select v-model="deviceForm.greenhouseId" style="width: 100%">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="设备名称"><el-input v-model.trim="deviceForm.name" /></el-form-item>
        <el-form-item label="设备类别"><el-input v-model.trim="deviceForm.category" /></el-form-item>
        <el-form-item label="设备状态">
          <el-select v-model="deviceForm.status" style="width: 100%">
            <el-option label="运行中" value="RUNNING" />
            <el-option label="已停止" value="STOPPED" />
            <el-option label="维护中" value="MAINTENANCE" />
          </el-select>
        </el-form-item>
        <el-form-item label="安装位置"><el-input v-model.trim="deviceForm.location" /></el-form-item>
        <el-form-item label="设备备注"><el-input v-model.trim="deviceForm.remark" type="textarea" :rows="3" /></el-form-item>
        <el-form-item label="健康度"><el-slider v-model="deviceForm.healthScore" :min="0" :max="100" show-input /></el-form-item>
        <div class="dialog-actions">
          <el-button @click="deviceDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitDevice">保存</el-button>
        </div>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createDevice, deleteDevice, fetchDevices, fetchGreenhouses, updateDevice } from '../services/greenhouse'
import { fetchFarmerGreenhouses, fetchUsers } from '../services/user'
import { useSessionStore } from '../stores/session'

const session = useSessionStore()
const isAdmin = computed(() => session.profile?.role === 'ADMIN')
const loading = ref(false)
const saving = ref(false)
const users = ref([])
const farmerId = ref(null)
const greenhouses = ref([])
const greenhouseId = ref(null)
const devices = ref([])
const deviceDialog = ref(false)
const editingId = ref(null)
const deviceForm = reactive({ greenhouseId: null, name: '', category: '', status: 'STOPPED', location: '', remark: '', autoMode: true, healthScore: 100 })

const farmers = computed(() => users.value.filter(item => item.role_code === 'FARMER'))
const visibleDevices = computed(() => devices.value.filter(item => !looksInvalid(item.name) && !looksInvalid(item.category)))
const userLabel = item => `${item.display_name || item.username}（${item.username}）`
const statusText = status => ({ RUNNING: '运行中', STOPPED: '已停止', MAINTENANCE: '维护中' }[status] || status)
const statusTag = status => status === 'RUNNING' ? 'success' : status === 'MAINTENANCE' ? 'warning' : 'info'
const looksInvalid = value => {
  const text = String(value || '').toLowerCase()
  return text.includes('????') || text.startsWith('farmer-device-') || text === 'test'
}
const displayText = (value, fallback) => {
  if (!value || looksInvalid(value)) return fallback
  return String(value).replace(/CO2/g, 'CO₂')
}

const onFarmerChange = async () => {
  greenhouses.value = farmerId.value ? await fetchFarmerGreenhouses(farmerId.value) : []
  greenhouseId.value = greenhouses.value[0]?.id || null
  await loadDevices()
}

const loadGreenhouses = async () => {
  if (isAdmin.value) return
  greenhouses.value = await fetchGreenhouses()
  greenhouseId.value = greenhouses.value[0]?.id || null
}

const loadDevices = async () => {
  if (!greenhouseId.value) {
    devices.value = []
    return
  }
  loading.value = true
  try {
    devices.value = await fetchDevices(greenhouseId.value)
  } finally {
    loading.value = false
  }
}

const resetForm = () => Object.assign(deviceForm, { greenhouseId: greenhouseId.value, name: '', category: '', status: 'STOPPED', location: '', remark: '', autoMode: true, healthScore: 100 })
const openCreate = () => { editingId.value = null; resetForm(); deviceDialog.value = true }
const openEdit = device => { editingId.value = device.id; Object.assign(deviceForm, { ...device, greenhouseId: device.greenhouseId || device.greenhouse_id || greenhouseId.value }); deviceDialog.value = true }

const submitDevice = async () => {
  if (!deviceForm.greenhouseId || !deviceForm.name || !deviceForm.category) return ElMessage.warning('请补全设备信息')
  saving.value = true
  try {
    if (editingId.value) await updateDevice(editingId.value, deviceForm)
    else await createDevice(deviceForm)
    ElMessage.success('设备档案已保存')
    deviceDialog.value = false
    await loadDevices()
  } finally {
    saving.value = false
  }
}

const removeDevice = async device => {
  await ElMessageBox.confirm(`确认删除设备“${device.name}”？`, '删除设备', {
    type: 'warning',
    confirmButtonText: '确定',
    cancelButtonText: '取消'
  })
  await deleteDevice(device.id)
  ElMessage.success('设备已删除')
  await loadDevices()
}

onMounted(async () => {
  if (isAdmin.value) users.value = await fetchUsers()
  await loadGreenhouses()
  await loadDevices()
})
</script>

<style scoped>
.panel-head, .head-actions, .dialog-actions { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
.head-actions { flex-wrap: wrap; justify-content: flex-end; }
.device-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; margin-top: 18px; }
.device-card { padding: 16px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255,255,255,.72); }
.device-card__top, .device-card__actions { display: flex; align-items: center; justify-content: space-between; gap: 10px; }
.device-card h3 { margin: 16px 0 6px; }
.device-card p { margin: 0 0 12px; color: var(--muted); }
.remark { color: #45604b; }
.device-card__actions { justify-content: flex-start; margin-top: 14px; }
.dialog-actions { justify-content: flex-end; }
</style>
