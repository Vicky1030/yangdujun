<template>
  <div class="page" v-loading="loading">
    <section class="hero-panel">
      <div>
        <span class="eyebrow">管理员工作台</span>
        <h2>管理员管理总览</h2>
        <p>先选择农户，再查看该农户绑定的大棚环境、设备和告警情况。</p>
      </div>
      <div class="query-box">
        <el-select v-model="farmerId" clearable placeholder="选择农户" style="width: 220px" @change="onFarmerChange">
          <el-option v-for="item in farmers" :key="item.id" :label="userLabel(item)" :value="item.id" />
        </el-select>
        <el-select v-model="greenhouseId" clearable placeholder="选择该农户的大棚" style="width: 240px" :disabled="!farmerId" @change="loadOverview">
          <el-option v-for="item in farmerGreenhouses" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
        <el-button type="primary" :disabled="!greenhouseId" @click="loadOverview">查询</el-button>
      </div>
    </section>

    <div class="admin-summary">
      <button class="summary-card" type="button" @click="router.push('/users')">
        <span>农户账号</span>
        <strong>{{ farmers.length }}</strong>
        <small>进入农户管理和大棚分配</small>
      </button>
      <button class="summary-card" type="button" @click="router.push('/devices')">
        <span>当前设备</span>
        <strong>{{ overview.devices.length }}</strong>
        <small>{{ selectedGreenhouse?.name || '请先查询大棚' }}</small>
      </button>
      <button class="summary-card danger" type="button" @click="router.push('/alerts?status=OPEN')">
        <span>未处理告警</span>
        <strong>{{ overview.activeAlerts.length }}</strong>
        <small>点击进入告警处理</small>
      </button>
      <button class="summary-card trace-card" type="button" @click="router.push('/traceability')">
        <span>批次溯源</span>
        <div class="mini-chain">
          <i /> <b /> <i /> <b /> <i />
        </div>
        <small>查看生产批次时间链</small>
      </button>
    </div>

    <section class="panel env-panel" :class="{ 'env-panel--active': queried }">
      <div class="panel-head">
        <div>
          <h2 class="section-title">当前大棚环境态势</h2>
          <p class="muted">{{ queried ? `当前数据来自 ${selectedGreenhouse?.name}` : '选择农户和大棚后，此卡片会浮动到总览下方展示。' }}</p>
        </div>
      </div>
      <el-empty v-if="!queried" description="尚未查询大棚" />
      <div v-else class="env-grid">
        <div class="env-card"><span>温度</span><strong>{{ telemetry.temperature ?? '-' }} ℃</strong></div>
        <div class="env-card"><span>湿度</span><strong>{{ telemetry.humidity ?? '-' }} %</strong></div>
        <div class="env-card"><span>CO<sub>2</sub> 浓度</span><strong>{{ telemetry.co2Ppm ?? '-' }} ppm</strong></div>
        <div class="env-card"><span>土壤湿度</span><strong>{{ telemetry.soilMoisture ?? '-' }} %</strong></div>
      </div>
    </section>

    <div class="split-grid">
      <section class="panel">
        <h2 class="section-title">设备简况</h2>
        <el-table :data="overview.devices" style="width: 100%; margin-top: 12px">
          <el-table-column prop="name" label="设备名称" min-width="180" />
          <el-table-column prop="category" label="类别" width="130" />
          <el-table-column prop="location" label="位置" min-width="150" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }"><el-tag>{{ deviceStatus(row.status) }}</el-tag></template>
          </el-table-column>
        </el-table>
      </section>
      <section class="panel">
        <h2 class="section-title">当前大棚告警</h2>
        <div class="alert-list">
          <article v-for="alert in overview.activeAlerts" :key="alert.id">
            <el-tag :type="alert.level === 'CRITICAL' ? 'danger' : 'warning'">{{ alertLevel(alert.level) }}</el-tag>
            <div><strong>{{ alert.title }}</strong><p>{{ alert.description }}</p></div>
          </article>
          <el-empty v-if="!overview.activeAlerts.length" description="当前没有未处理告警" />
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchOverview } from '../services/greenhouse'
import { fetchFarmerGreenhouses, fetchUsers } from '../services/user'

const router = useRouter()
const loading = ref(false)
const users = ref([])
const farmerId = ref(null)
const greenhouseId = ref(null)
const farmerGreenhouses = ref([])
const queried = ref(false)
const overview = ref({ greenhouses: [], devices: [], activeAlerts: [], currentTelemetry: {} })

const farmers = computed(() => users.value.filter(item => item.role_code === 'FARMER'))
const telemetry = computed(() => overview.value.currentTelemetry || {})
const selectedGreenhouse = computed(() => farmerGreenhouses.value.find(item => item.id === greenhouseId.value))
const userLabel = item => `${item.display_name || item.username}（${item.username}）`
const deviceStatus = status => ({ RUNNING: '运行中', STOPPED: '已停止', MAINTENANCE: '维护中' }[status] || status)
const alertLevel = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level)

const onFarmerChange = async () => {
  greenhouseId.value = null
  farmerGreenhouses.value = farmerId.value ? await fetchFarmerGreenhouses(farmerId.value) : []
  overview.value = { greenhouses: [], devices: [], activeAlerts: [], currentTelemetry: {} }
  queried.value = false
}

const loadOverview = async () => {
  if (!greenhouseId.value) return
  loading.value = true
  try {
    overview.value = await fetchOverview(greenhouseId.value)
    queried.value = true
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  users.value = await fetchUsers()
})
</script>

<style scoped>
.hero-panel, .query-box, .panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}
.hero-panel {
  padding: 28px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.9);
  box-shadow: var(--shadow);
}
.eyebrow { color: var(--brand-strong); font-weight: 900; }
.hero-panel h2 { margin: 8px 0; font-size: 34px; }
.hero-panel p { margin: 0; color: var(--muted); }
.admin-summary, .env-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 16px; }
.summary-card, .env-card {
  min-height: 128px;
  padding: 20px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.86);
  text-align: left;
  cursor: pointer;
}
.summary-card span, .env-card span { color: var(--muted); }
.summary-card strong, .env-card strong { display: block; margin-top: 12px; font-size: 30px; }
.summary-card.danger strong { color: var(--danger); }
.mini-chain { display: flex; align-items: center; gap: 8px; margin: 18px 0 12px; }
.mini-chain i { width: 16px; height: 16px; border-radius: 50%; background: var(--brand); }
.mini-chain b { flex: 1; height: 2px; background: rgba(64, 145, 76, .28); }
.env-panel { order: 10; transition: transform .24s ease, box-shadow .24s ease; }
.env-panel--active { order: 0; transform: translateY(-4px); box-shadow: 0 22px 58px rgba(42,91,48,.18); }
.alert-list { display: grid; gap: 12px; margin-top: 12px; }
.alert-list article { display: flex; gap: 12px; padding: 12px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255,255,255,.7); }
.alert-list p { margin: 6px 0 0; color: var(--muted); }
</style>
