<template>
  <div class="page" v-loading="loading">
    <section class="hero-panel">
      <div>
        <span class="eyebrow">智能生态调控中枢</span>
        <h2>管理员管理总览</h2>
        <p>聚合大棚、设备、环境和告警信息。点击关键卡片可以直接进入对应处理界面。</p>
      </div>
      <div class="hero-orbit" aria-hidden="true">
        <span />
        <strong>AI</strong>
      </div>
      <div class="hero-actions">
        <el-select v-model="greenhouseId" style="width: 260px" @change="load">
          <el-option v-for="item in overview.greenhouses" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
        <el-button type="primary" @click="greenhouseDialog = true">添加大棚</el-button>
      </div>
    </section>

    <div class="admin-summary">
      <button class="summary-card" type="button" @click="scrollToGreenhouses">
        <span>管理大棚</span>
        <strong>{{ overview.greenhouses.length }}</strong>
        <small>在线 {{ onlineCount }} 个，异常 {{ warningCount }} 个</small>
      </button>
      <button class="summary-card" type="button" @click="focusGreenhouse">
        <span>当前选中大棚</span>
        <strong>{{ selectedGreenhouse?.name || '-' }}</strong>
        <small>{{ selectedGreenhouse?.location || '暂无位置' }}</small>
      </button>
      <button class="summary-card" type="button" @click="router.push('/devices')">
        <span>设备运行</span>
        <strong>{{ runningDeviceCount }}/{{ overview.devices.length }}</strong>
        <small>点击进入设备管理</small>
      </button>
      <button class="summary-card danger" type="button" @click="router.push('/alerts?status=OPEN')">
        <span>未处理告警</span>
        <strong>{{ overview.activeAlerts.length }}</strong>
        <small>点击进入告警处理</small>
      </button>
    </div>

    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">大棚环境态势</h2>
          <p class="muted">当前数据来自 {{ selectedGreenhouse?.name || '选中大棚' }}，用于判断羊肚菌生长环境是否稳定。</p>
        </div>
        <el-button @click="router.push('/traceability')">查看批次溯源</el-button>
      </div>

      <div class="env-grid">
        <div class="env-card">
          <span>温度</span>
          <strong>{{ telemetry.temperature ?? '-' }} ℃</strong>
          <small>{{ selectedGreenhouse?.name || '当前大棚' }}</small>
        </div>
        <div class="env-card">
          <span>湿度</span>
          <strong>{{ telemetry.humidity ?? '-' }} %</strong>
          <small>{{ selectedGreenhouse?.name || '当前大棚' }}</small>
        </div>
        <div class="env-card">
          <span>CO<sub>2</sub> 浓度</span>
          <strong>{{ telemetry.co2Ppm ?? '-' }} ppm</strong>
          <small>{{ selectedGreenhouse?.name || '当前大棚' }}</small>
        </div>
        <div class="env-card">
          <span>土壤湿度</span>
          <strong>{{ telemetry.soilMoisture ?? '-' }} %</strong>
          <small>{{ selectedGreenhouse?.name || '当前大棚' }}</small>
        </div>
      </div>
    </section>

    <div class="split-grid">
      <section ref="greenhouseSection" class="panel">
        <h2 class="section-title">大棚清单</h2>
        <el-table :data="overview.greenhouses" style="width: 100%; margin-top: 12px" @row-click="selectGreenhouse">
          <el-table-column prop="name" label="大棚名称" min-width="180" />
          <el-table-column prop="location" label="位置" min-width="160" />
          <el-table-column prop="area" label="面积(㎡)" width="110" />
          <el-table-column prop="cropStage" label="生产阶段" width="130" />
          <el-table-column label="状态" width="110">
            <template #default="{ row }">
              <el-tag :type="statusTag(row.status)">{{ statusText(row.status) }}</el-tag>
            </template>
          </el-table-column>
        </el-table>
      </section>

      <section class="panel">
        <div class="panel-head compact">
          <h2 class="section-title">待处理告警</h2>
          <el-button link type="primary" @click="router.push('/alerts?status=OPEN')">全部处理</el-button>
        </div>
        <div class="alert-list">
          <article v-for="alert in overview.activeAlerts" :key="alert.id" @click="router.push('/alerts?status=OPEN')">
            <el-tag :type="alert.level === 'CRITICAL' ? 'danger' : 'warning'">{{ levelText(alert.level) }}</el-tag>
            <div>
              <strong>{{ alert.title }}</strong>
              <p>{{ alert.description }}</p>
            </div>
          </article>
          <el-empty v-if="!overview.activeAlerts.length" description="当前大棚暂无未处理告警" />
        </div>
      </section>
    </div>

    <el-dialog v-model="greenhouseDialog" title="添加大棚" width="520px">
      <el-form label-position="top">
        <el-form-item label="大棚名称"><el-input v-model.trim="greenhouseForm.name" /></el-form-item>
        <el-form-item label="位置"><el-input v-model.trim="greenhouseForm.location" /></el-form-item>
        <el-form-item label="面积(㎡)"><el-input-number v-model="greenhouseForm.area" :min="1" style="width: 100%" /></el-form-item>
        <el-form-item label="生产阶段"><el-input v-model.trim="greenhouseForm.cropStage" placeholder="如：出菇期、育菇期、休整期" /></el-form-item>
        <el-button type="primary" :loading="saving" @click="submitGreenhouse">确认添加</el-button>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createGreenhouse, fetchOverview } from '../services/greenhouse'

const router = useRouter()
const loading = ref(false)
const saving = ref(false)
const greenhouseDialog = ref(false)
const greenhouseId = ref(null)
const greenhouseSection = ref(null)
const greenhouseForm = reactive({ name: '', location: '', area: 100, cropStage: '' })
const overview = ref({
  greenhouses: [],
  devices: [],
  activeAlerts: [],
  productionSummary: {},
  currentTelemetry: {}
})

const telemetry = computed(() => overview.value.currentTelemetry || {})
const selectedGreenhouse = computed(() => overview.value.greenhouses.find(item => item.id === greenhouseId.value))
const onlineCount = computed(() => overview.value.greenhouses.filter(item => item.status === 'ONLINE').length)
const warningCount = computed(() => overview.value.greenhouses.filter(item => item.status === 'WARNING').length)
const runningDeviceCount = computed(() => overview.value.devices.filter(item => item.status === 'RUNNING').length)

const statusText = status => ({ ONLINE: '在线', WARNING: '预警', OFFLINE: '离线' }[status] || status)
const statusTag = status => status === 'ONLINE' ? 'success' : status === 'WARNING' ? 'warning' : 'info'
const levelText = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level)

const load = async () => {
  loading.value = true
  try {
    overview.value = await fetchOverview(greenhouseId.value)
    greenhouseId.value = overview.value.currentTelemetry?.greenhouseId || greenhouseId.value || overview.value.greenhouses[0]?.id
  } finally {
    loading.value = false
  }
}

const selectGreenhouse = async (row) => {
  greenhouseId.value = row.id
  await load()
}

const scrollToGreenhouses = () => greenhouseSection.value?.$el?.scrollIntoView?.({ behavior: 'smooth', block: 'start' })
const focusGreenhouse = () => {
  if (!selectedGreenhouse.value) return ElMessage.info('请先选择一个大棚')
  scrollToGreenhouses()
}

const submitGreenhouse = async () => {
  if (!greenhouseForm.name) return ElMessage.warning('请填写大棚名称')
  saving.value = true
  try {
    await createGreenhouse(greenhouseForm)
    ElMessage.success('大棚已添加')
    greenhouseDialog.value = false
    Object.assign(greenhouseForm, { name: '', location: '', area: 100, cropStage: '' })
    await load()
  } finally {
    saving.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.hero-panel {
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  min-height: 176px;
  padding: 28px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background:
    radial-gradient(circle at 18% 18%, rgba(168, 211, 111, 0.22), transparent 34%),
    radial-gradient(circle at 78% 30%, rgba(154, 185, 151, 0.16), transparent 28%),
    linear-gradient(135deg, rgba(31, 57, 39, 0.88), rgba(7, 16, 11, 0.78));
  box-shadow: var(--shadow);
}

.hero-panel::before {
  content: "";
  position: absolute;
  inset: auto 20% -70px 10%;
  height: 150px;
  background:
    linear-gradient(90deg, transparent, rgba(168, 211, 111, 0.18), transparent),
    repeating-linear-gradient(90deg, rgba(154, 185, 151, 0.16) 0 1px, transparent 1px 38px);
  transform: perspective(360px) rotateX(62deg);
  transform-origin: bottom;
}

.hero-panel > * {
  position: relative;
  z-index: 1;
}

.eyebrow {
  color: var(--brand);
  font-weight: 900;
}

.hero-panel h2 {
  margin: 8px 0;
  color: #f7fffb;
  font-size: 34px;
}

.hero-panel p {
  margin: 0;
  color: var(--muted);
}

.hero-orbit {
  position: absolute;
  right: 330px;
  top: 24px;
  display: grid;
  width: 104px;
  height: 104px;
  place-items: center;
  border: 1px solid rgba(168, 211, 111, 0.22);
  border-radius: 50%;
  background: radial-gradient(circle, rgba(168, 211, 111, 0.2), transparent 62%);
  opacity: 0.9;
}

.hero-orbit span {
  position: absolute;
  inset: 12px;
  border: 1px dashed rgba(241, 248, 237, 0.26);
  border-radius: 50%;
  animation: orbit-spin 18s linear infinite;
}

.hero-orbit strong {
  color: var(--brand);
  font-size: 22px;
}

.hero-actions,
.panel-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.panel-head {
  margin-bottom: 16px;
}

.panel-head.compact {
  align-items: center;
}

.admin-summary,
.env-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.summary-card,
.env-card {
  position: relative;
  overflow: hidden;
  min-height: 132px;
  padding: 20px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background:
    radial-gradient(circle at 12% 12%, rgba(168, 211, 111, 0.16), transparent 34%),
    linear-gradient(145deg, rgba(28, 52, 36, 0.82), rgba(7, 17, 11, 0.78));
  color: inherit;
  text-align: left;
  box-shadow: var(--shadow);
  cursor: pointer;
  transition: transform 220ms ease, border-color 220ms ease, box-shadow 220ms ease;
}

.summary-card::after,
.env-card::after {
  content: "";
  position: absolute;
  right: -24px;
  bottom: -24px;
  width: 92px;
  height: 92px;
  border: 1px solid rgba(168, 211, 111, 0.18);
  border-radius: 50%;
  background: rgba(154, 185, 151, 0.045);
}

.summary-card small,
.env-card small {
  color: var(--muted);
}

.summary-card.danger strong {
  color: var(--danger);
}

.alert-list {
  display: grid;
  gap: 12px;
  margin-top: 16px;
}

.alert-list article {
  display: flex;
  gap: 12px;
  padding: 14px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(154, 185, 151, 0.07);
  cursor: pointer;
}

.alert-list p {
  margin: 6px 0 0;
  color: var(--muted);
}

@keyframes orbit-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 1080px) {
  .admin-summary,
  .env-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .admin-summary,
  .env-grid,
  .hero-panel {
    grid-template-columns: 1fr;
  }

  .hero-panel,
  .panel-head,
  .hero-actions {
    flex-direction: column;
    align-items: stretch;
  }

  .hero-orbit {
    display: none;
  }
}
</style>
