<template>
  <div class="page" v-loading="loading">
    <div class="admin-summary">
      <div class="summary-card">
        <span>管理大棚</span>
        <strong>{{ overview.greenhouses.length }}</strong>
        <small>在线 {{ onlineCount }} 个，异常 {{ warningCount }} 个</small>
      </div>
      <div class="summary-card">
        <span>当前选中大棚</span>
        <strong>{{ selectedGreenhouse?.name || '-' }}</strong>
        <small>{{ selectedGreenhouse?.location || '暂无位置' }}</small>
      </div>
      <div class="summary-card">
        <span>设备运行</span>
        <strong>{{ runningDeviceCount }}/{{ overview.devices.length }}</strong>
        <small>运行设备 / 当前大棚设备总数</small>
      </div>
      <div class="summary-card danger">
        <span>未处理告警</span>
        <strong>{{ overview.activeAlerts.length }}</strong>
        <small>需要管理员跟进</small>
      </div>
    </div>

    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">大棚监管视图</h2>
          <p class="muted">选择大棚后查看该大棚的环境数据、设备状态与未处理告警。</p>
        </div>
        <div class="head-actions">
          <el-select v-model="greenhouseId" style="width: 260px" @change="load">
            <el-option v-for="item in overview.greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
          <el-button type="primary" @click="greenhouseDialog = true">添加大棚</el-button>
        </div>
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
      <section class="panel">
        <h2 class="section-title">大棚清单</h2>
        <el-table :data="overview.greenhouses" style="width: 100%; margin-top: 12px">
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
        <h2 class="section-title">当前大棚待办</h2>
        <div class="alert-list">
          <article v-for="alert in overview.activeAlerts" :key="alert.id">
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
        <el-form-item label="生产阶段"><el-input v-model.trim="greenhouseForm.cropStage" placeholder="如 出菇期、育菇期、休整期" /></el-form-item>
        <el-button type="primary" :loading="saving" @click="submitGreenhouse">确认添加</el-button>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { createGreenhouse, fetchOverview } from '../services/greenhouse'

const loading = ref(false)
const saving = ref(false)
const greenhouseDialog = ref(false)
const greenhouseId = ref(null)
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
    greenhouseId.value = overview.value.currentTelemetry?.greenhouseId || overview.value.greenhouses[0]?.id
  } finally {
    loading.value = false
  }
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
.admin-summary,
.env-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.summary-card,
.env-card {
  padding: 18px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: #fff;
}

.summary-card span,
.env-card span {
  color: var(--muted);
}

.summary-card strong,
.env-card strong {
  display: block;
  margin: 10px 0 4px;
  color: #10251c;
  font-size: 26px;
}

.summary-card small,
.env-card small {
  color: var(--muted);
}

.summary-card.danger strong {
  color: #b42318;
}

.panel-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.head-actions {
  display: flex;
  gap: 10px;
  align-items: center;
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
  background: var(--panel-soft);
}

.alert-list p {
  margin: 6px 0 0;
  color: var(--muted);
}

@media (max-width: 1080px) {
  .admin-summary,
  .env-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .admin-summary,
  .env-grid {
    grid-template-columns: 1fr;
  }

  .panel-head,
  .head-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
