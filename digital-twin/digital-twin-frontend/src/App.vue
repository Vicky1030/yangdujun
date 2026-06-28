<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import GreenhouseScene from './components/GreenhouseScene.vue'
import { fetchTwinOverview, updateDeviceCommand } from './api/twinApi'
import { mockTwinData } from './data/mockTwinData'

const twinData = ref(structuredClone(mockTwinData))
const selected = ref({ type: 'greenhouse', id: 'GH-001' })
const dataSource = ref('MOCK')
const loading = ref(false)
const errorMessage = ref('')
const localDeviceOverrides = ref({})
const infoPage = ref(0)

const pageNames = ['告警信息', '设备运行情况', '环境数据']

const selectedGreenhouse = computed(() => {
  if (selected.value.type === 'greenhouse') {
    return twinData.value.greenhouses.find((item) => item.id === selected.value.id)
  }
  if (selected.value.type === 'device') {
    const device = twinData.value.devices.find((item) => item.deviceId === selected.value.id)
    return twinData.value.greenhouses.find((item) => item.id === device?.greenhouseId)
  }
  if (selected.value.type === 'sensor') {
    const sensor = twinData.value.sensors.find((item) => item.deviceId === selected.value.id)
    return twinData.value.greenhouses.find((item) => item.id === sensor?.greenhouseId)
  }
  return twinData.value.greenhouses[0]
})

const currentGreenhouseId = computed(() => selectedGreenhouse.value?.id || twinData.value.greenhouses[0]?.id)

const currentAlerts = computed(() => {
  const rows = twinData.value.alerts?.filter((item) => item.greenhouseId === currentGreenhouseId.value) || []
  return rows.length ? rows : twinData.value.alerts || []
})

const currentDevices = computed(() => (
  twinData.value.devices.filter((item) => item.greenhouseId === currentGreenhouseId.value)
))

const currentSensors = computed(() => (
  twinData.value.sensors.filter((item) => item.greenhouseId === currentGreenhouseId.value).length
    ? twinData.value.sensors.filter((item) => item.greenhouseId === currentGreenhouseId.value)
    : twinData.value.sensors
))

const alarmCount = computed(() => currentAlerts.value.filter((alert) => alert.status === 'OPEN').length)

function applyLocalDeviceOverrides(data) {
  data.devices = data.devices.map((device) => ({
    ...device,
    runningStatus: localDeviceOverrides.value[device.deviceId] || device.runningStatus,
  }))
  return data
}

async function loadTwinData() {
  loading.value = true
  try {
    const remoteData = await fetchTwinOverview()
    twinData.value = applyLocalDeviceOverrides(remoteData)
    dataSource.value = 'KINGBASE'
    errorMessage.value = ''
  } catch (error) {
    dataSource.value = 'MOCK'
    errorMessage.value = error.message
  } finally {
    loading.value = false
  }
}

function handleSelect(payload) {
  selected.value = payload
  if (payload.type === 'greenhouse') infoPage.value = 0
}

function prevPage() {
  infoPage.value = (infoPage.value + pageNames.length - 1) % pageNames.length
}

function nextPage() {
  infoPage.value = (infoPage.value + 1) % pageNames.length
}

async function toggleDevice(deviceId) {
  const device = twinData.value.devices.find((item) => item.deviceId === deviceId)
  if (!device) return

  const nextStatus = device.runningStatus === 'ON' ? 'OFF' : 'ON'
  localDeviceOverrides.value = {
    ...localDeviceOverrides.value,
    [device.deviceId]: nextStatus,
  }
  device.runningStatus = nextStatus
  twinData.value.updatedAt = new Date().toLocaleTimeString('zh-CN', { hour12: false })
  selected.value = { type: 'device', id: device.deviceId }

  try {
    const result = await updateDeviceCommand(device, nextStatus)
    if (!result?.localOnly) await loadTwinData()
  } catch (error) {
    errorMessage.value = `设备状态已在大屏临时切换，但写入数据库失败：${error.message}`
  }
}

let refreshTimer

onMounted(() => {
  loadTwinData()
  refreshTimer = window.setInterval(loadTwinData, 5000)
})

onBeforeUnmount(() => window.clearInterval(refreshTimer))
</script>

<template>
  <main class="dashboard-shell">
    <header class="topbar">
      <div class="brand-block">
        <div class="title-line">
          <h1>智慧羊肚菌大棚 · 数字孪生中心</h1>
          <span class="title-badge">SMART MOREL GREENHOUSE</span>
        </div>
        <p class="subtitle">系统开发实训项目 · 温芯菌控可视化平台</p>
      </div>
      <div :class="['connection-chip', dataSource.toLowerCase()]">
        <span></span>
        {{ dataSource === 'KINGBASE' ? '金仓数据库已连接' : '模拟数据运行中' }}
      </div>
    </header>

    <p v-if="errorMessage" class="error-banner">
      {{ errorMessage }}。请确认后端已启动，且电脑仍连接同伴 WiFi。
    </p>

    <section class="info-carousel">
      <button class="page-arrow" @click="prevPage">‹</button>
      <article class="info-panel">
        <div class="info-header">
          <div>
            <p class="panel-kicker">{{ selectedGreenhouse?.name || '大棚总览' }}</p>
            <h2>{{ pageNames[infoPage] }}</h2>
          </div>
          <div class="page-dots">
            <button
              v-for="(_, index) in pageNames"
              :key="index"
              :class="{ active: infoPage === index }"
              @click="infoPage = index"
            />
          </div>
        </div>

        <div v-if="infoPage === 0" class="info-list alarm-list">
          <div v-if="!currentAlerts.length" class="empty-text">当前大棚暂无告警。</div>
          <div v-for="alert in currentAlerts.slice(0, 4)" :key="alert.id" class="info-item">
            <strong>{{ alert.title || '未命名告警' }}</strong>
            <span>{{ alert.level }} · {{ alert.status }}</span>
            <p>{{ alert.description || '暂无告警描述' }}</p>
          </div>
        </div>

        <div v-else-if="infoPage === 1" class="info-list device-summary">
          <div v-if="!currentDevices.length" class="empty-text">当前大棚暂无接入设备。</div>
          <button
            v-for="device in currentDevices"
            :key="device.deviceId"
            :class="['device-control-card', device.runningStatus.toLowerCase()]"
            @click="toggleDevice(device.deviceId)"
          >
            <span>
              <strong>{{ device.name }}</strong>
              <small>{{ device.location || device.deviceId }}</small>
            </span>
            <b>{{ device.runningStatus }}</b>
          </button>
        </div>

        <div v-else class="env-grid">
          <div v-for="sensor in currentSensors" :key="sensor.deviceId" class="env-item">
            <span>{{ sensor.name }}</span>
            <strong>{{ sensor.value }}<small>{{ sensor.unit }}</small></strong>
            <em :class="sensor.status.toLowerCase()">{{ sensor.status === 'NORMAL' ? '正常' : '预警' }}</em>
          </div>
        </div>
      </article>
      <button class="page-arrow" @click="nextPage">›</button>
    </section>

    <section class="content-grid">
      <article class="scene-panel">
        <div class="panel-heading scene-heading">
          <div>
            <p class="panel-kicker">实时场景</p>
            <h2>四棚联动孪生视图</h2>
          </div>
          <div class="scene-actions">
            <span class="sync-text">{{ loading ? '正在同步数据库...' : `告警 ${alarmCount} 条 · ${twinData.updatedAt}` }}</span>
          </div>
        </div>
        <GreenhouseScene :twin-data="twinData" :selected="selected" @entity-select="handleSelect" />
      </article>
    </section>
  </main>
</template>
