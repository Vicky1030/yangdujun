<template>
  <div class="page" v-loading="loading">
    <section class="farmer-hero panel">
      <div>
        <span class="eyebrow">农户 Web 工作台</span>
        <h2>{{ displayName }} 的大棚看护台</h2>
        <p>查看已绑定大棚的环境指标、设备状态、待处理告警和今日巡检建议。</p>
      </div>
      <div class="hero-actions">
        <el-select v-if="overview.greenhouses.length" v-model="greenhouseId" style="width: 240px" @change="load">
          <el-option v-for="item in overview.greenhouses" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
        <el-button @click="openGreenhouseDialog">添加大棚</el-button>
        <el-button type="primary" @click="$router.push('/profile')">完善资料</el-button>
      </div>
    </section>

    <section v-if="isEmptyFarmer" class="panel empty-workbench">
      <div>
        <span class="eyebrow">可以先创建自己的大棚</span>
        <h3>当前账号还没有大棚或设备数据</h3>
        <p>你可以自己添加大棚，系统会自动绑定到当前账号。设备、批次和告警数据可以后续继续补充。</p>
      </div>
      <el-button type="primary" @click="openGreenhouseDialog">添加大棚</el-button>
    </section>

    <template v-else>
      <div class="metric-grid farmer-metrics">
        <button class="metric-card" type="button" @click="$router.push('/analytics')">
          <span>空气温度</span>
          <strong>{{ telemetry.airTemperature ?? '-' }} ℃</strong>
          <small>{{ temperatureAdvice }}</small>
        </button>
        <button class="metric-card" type="button" @click="$router.push('/analytics')">
          <span>空气湿度</span>
          <strong>{{ telemetry.airHumidity ?? '-' }} %</strong>
          <small>{{ humidityAdvice }}</small>
        </button>
        <button class="metric-card" type="button" @click="$router.push('/analytics')">
          <span>土壤温湿度</span>
          <strong>{{ telemetry.soilTemperature ?? '-' }} ℃ / {{ telemetry.soilHumidity ?? '-' }} %</strong>
          <small>pH {{ telemetry.phValue ?? '-' }}</small>
        </button>
        <button class="metric-card" type="button" @click="$router.push('/analytics')">
          <span>二氧化碳 / 光照</span>
          <strong>{{ telemetry.co2Ppm ?? '-' }} ppm</strong>
          <small>{{ telemetry.lightLux ?? '-' }} lx · {{ co2Advice }}</small>
        </button>
        <button class="metric-card" type="button" @click="$router.push('/alerts?status=OPEN')">
          <span>待处理告警</span>
          <strong>{{ overview.activeAlerts?.length || 0 }}</strong>
          <small>{{ overview.activeAlerts?.length ? '请及时查看并处理' : '当前环境稳定' }}</small>
        </button>
      </div>

      <div class="action-grid">
        <button type="button" @click="$router.push('/devices')">设备管理</button>
        <button type="button" @click="$router.push('/alerts')">告警处理</button>
        <button type="button" @click="$router.push('/analytics')">数据分析</button>
        <button type="button" @click="$router.push('/traceability')">批次溯源</button>
      </div>

      <div class="split-grid">
        <section class="panel">
          <div class="panel-head compact">
            <h2 class="section-title">今日巡检建议</h2>
            <el-tag type="success">{{ selectedGreenhouse?.cropStage || '生产期' }}</el-tag>
          </div>
          <div class="task-list">
            <article v-for="task in dailyTasks" :key="task.title">
              <strong>{{ task.title }}</strong>
              <p>{{ task.detail }}</p>
            </article>
          </div>
        </section>

        <section class="panel">
          <div class="panel-head compact">
            <h2 class="section-title">待关注告警</h2>
            <el-button link type="primary" @click="$router.push('/alerts')">查看全部</el-button>
          </div>
          <div class="alert-list">
            <article v-for="alert in overview.activeAlerts" :key="alert.id">
              <el-tag :type="alert.level === 'CRITICAL' ? 'danger' : 'warning'" size="small">{{ levelText(alert.level) }}</el-tag>
              <div>
                <strong>{{ alert.title }}</strong>
                <p>{{ alert.description }}</p>
              </div>
            </article>
            <el-empty v-if="!overview.activeAlerts?.length" description="当前没有待关注告警" />
          </div>
        </section>
      </div>

      <section class="panel">
        <div class="panel-head compact">
          <h2 class="section-title">我的设备</h2>
          <el-button link type="primary" @click="$router.push('/devices')">维护设备</el-button>
        </div>
        <el-table :data="overview.devices" style="width: 100%; margin-top: 16px">
          <el-table-column prop="name" label="设备" min-width="180" show-overflow-tooltip />
          <el-table-column prop="category" label="类型" width="140" />
          <el-table-column prop="location" label="安装位置" min-width="170" show-overflow-tooltip />
          <el-table-column prop="status" label="状态" width="110" align="center">
            <template #default="{ row }">
              <el-tag :type="deviceTag(row.status)" size="small">{{ statusText(row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="healthScore" label="健康度" width="180">
            <template #default="{ row }">
              <el-progress :percentage="row.healthScore" :stroke-width="8" :status="row.healthScore < 60 ? 'exception' : undefined" />
            </template>
          </el-table-column>
        </el-table>
      </section>
    </template>

    <el-dialog v-model="greenhouseDialog" title="添加大棚" width="560px">
      <el-form label-position="top">
        <el-form-item label="大棚名称"><el-input v-model.trim="greenhouseForm.name" /></el-form-item>
        <el-form-item label="位置"><el-input v-model.trim="greenhouseForm.location" /></el-form-item>
        <el-form-item label="面积（平方米）"><el-input-number v-model="greenhouseForm.area" :min="1" style="width: 100%" /></el-form-item>
        <el-form-item label="生产阶段"><el-input v-model.trim="greenhouseForm.cropStage" /></el-form-item>
        <div class="dialog-actions">
          <el-button @click="greenhouseDialog = false">取消</el-button>
          <el-button type="primary" :loading="savingGreenhouse" @click="submitGreenhouse">保存</el-button>
        </div>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createGreenhouse, fetchOverview } from '../services/greenhouse'
import { useSessionStore } from '../stores/session'

const session = useSessionStore()
const loading = ref(false)
const savingGreenhouse = ref(false)
const greenhouseDialog = ref(false)
const greenhouseId = ref(null)
const greenhouseForm = reactive({ name: '', location: '', area: 300, cropStage: '出菇期' })
const overview = ref({ greenhouses: [], devices: [], activeAlerts: [], currentTelemetry: {} })

const displayName = computed(() => session.profile?.username || '农户')
const isEmptyFarmer = computed(() => !overview.value.greenhouses.length)
const telemetry = computed(() => overview.value.currentTelemetry || {})
const selectedGreenhouse = computed(() => overview.value.greenhouses.find(item => item.id === greenhouseId.value))

const statusText = status => ({ RUNNING: '运行中', STOPPED: '已停止', MAINTENANCE: '维护中' }[status] || status)
const deviceTag = status => status === 'RUNNING' ? 'success' : status === 'MAINTENANCE' ? 'warning' : 'info'
const levelText = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level)

const temperatureAdvice = computed(() => {
  const value = telemetry.value.airTemperature
  if (value == null) return '等待采集'
  if (value < 16) return '温度偏低，注意保温'
  if (value > 24) return '温度偏高，建议通风'
  return '适合羊肚菌生长'
})

const humidityAdvice = computed(() => {
  const value = telemetry.value.airHumidity
  if (value == null) return '等待采集'
  if (value < 70) return '湿度偏低，注意补湿'
  if (value > 92) return '湿度偏高，留意病害风险'
  return '湿度处于合理区间'
})

const co2Advice = computed(() => {
  const value = telemetry.value.co2Ppm
  if (value == null) return '等待采集'
  if (value > 1200) return '浓度偏高，建议通风'
  if (value < 450) return '浓度偏低，关注通风策略'
  return '浓度正常'
})

const dailyTasks = computed(() => [
  { title: '检查棚内空气湿度和地表状态', detail: humidityAdvice.value },
  { title: '巡看通风和加湿设备', detail: `${overview.value.devices.filter(item => item.status === 'RUNNING').length} 台设备运行中，维护设备需优先确认。` },
  { title: '记录生产阶段观察情况', detail: selectedGreenhouse.value?.cropStage ? `当前阶段：${selectedGreenhouse.value.cropStage}` : '请补充当前生产阶段。' }
])

const openGreenhouseDialog = () => {
  Object.assign(greenhouseForm, { name: '', location: '', area: 300, cropStage: '出菇期' })
  greenhouseDialog.value = true
}

const submitGreenhouse = async () => {
  if (!greenhouseForm.name) return ElMessage.warning('请填写大棚名称')
  savingGreenhouse.value = true
  try {
    await createGreenhouse({ ...greenhouseForm })
    ElMessage.success('大棚已创建并自动绑定到当前账号')
    greenhouseDialog.value = false
    await load()
    greenhouseId.value = overview.value.greenhouses.at(-1)?.id || greenhouseId.value
  } finally {
    savingGreenhouse.value = false
  }
}

const load = async () => {
  loading.value = true
  try {
    overview.value = await fetchOverview(greenhouseId.value)
    greenhouseId.value = overview.value.currentTelemetry?.greenhouseId || greenhouseId.value || overview.value.greenhouses[0]?.id || null
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.farmer-hero,
.empty-workbench,
.panel-head,
.hero-actions,
.dialog-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}
.dialog-actions { justify-content: flex-end; margin-top: 16px; }
.eyebrow { color: var(--brand-strong); font-weight: 900; }
.farmer-hero h2,
.empty-workbench h3 { margin: 8px 0; color: var(--ink); font-size: 30px; }
.farmer-hero p,
.empty-workbench p { max-width: 760px; color: var(--muted); line-height: 1.8; }
.empty-workbench {
  min-height: 260px;
  background: radial-gradient(circle at 12% 20%, rgba(83, 184, 106, 0.14), transparent 34%), linear-gradient(145deg, rgba(255, 255, 255, 0.94), rgba(239, 250, 235, 0.86));
}
.metric-card { text-align: left; cursor: pointer; }
.farmer-metrics small { display: block; margin-top: 8px; color: var(--muted); }
.action-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 14px; }
.action-grid button {
  min-height: 76px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.8);
  color: var(--ink);
  font-size: 17px;
  font-weight: 900;
  cursor: pointer;
}
.task-list,
.alert-list { display: grid; gap: 12px; }
.task-list article,
.alert-list article { padding: 14px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255, 255, 255, 0.72); }
.alert-list article { display: flex; gap: 12px; }
.task-list p,
.alert-list p { margin: 6px 0 0; color: var(--muted); line-height: 1.7; }
@media (max-width: 760px) {
  .farmer-hero,
  .empty-workbench,
  .panel-head,
  .hero-actions { flex-direction: column; align-items: stretch; }
  .action-grid { grid-template-columns: 1fr; }
}
</style>
