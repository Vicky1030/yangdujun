<template>
  <div class="page" v-loading="loading">
    <section class="farmer-hero panel">
      <div>
        <span class="eyebrow">农户 Web 工作台</span>
        <h2>{{ session.profile?.username }} 的大棚工作台</h2>
        <p>查看已绑定大棚的环境、告警和设备信息。新注册用户默认不展示示范数据。</p>
      </div>
      <el-button type="primary" @click="$router.push('/profile')">完善资料</el-button>
    </section>

    <section v-if="isFreshFarmer" class="panel empty-workbench">
      <div>
        <span class="eyebrow">等待管理员绑定</span>
        <h3>当前账号还没有大棚或设备数据</h3>
        <p>请联系管理员为你分配大棚、绑定设备和创建生产批次。绑定完成后，这里会显示你的实时环境、告警和设备状态。</p>
      </div>
      <el-button @click="$router.push('/profile')">查看个人资料</el-button>
    </section>

    <template v-else>
      <div class="metric-grid">
        <div class="metric-card"><span>温度</span><strong>{{ overview.currentTelemetry?.temperature ?? '-' }} ℃</strong></div>
        <div class="metric-card"><span>湿度</span><strong>{{ overview.currentTelemetry?.humidity ?? '-' }} %</strong></div>
        <div class="metric-card"><span>CO<sub>2</sub></span><strong>{{ overview.currentTelemetry?.co2Ppm ?? '-' }} ppm</strong></div>
        <div class="metric-card"><span>未处理告警</span><strong>{{ overview.activeAlerts?.length || 0 }}</strong></div>
      </div>

      <section class="panel">
        <h2 class="section-title">我的设备</h2>
        <el-table :data="overview.devices" style="width: 100%; margin-top: 16px">
          <el-table-column prop="name" label="设备" />
          <el-table-column prop="category" label="类型" />
          <el-table-column prop="status" label="状态">
            <template #default="{ row }">{{ statusText(row.status) }}</template>
          </el-table-column>
          <el-table-column prop="healthScore" label="健康度" />
        </el-table>
      </section>
    </template>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { fetchOverview } from '../services/greenhouse'
import { useSessionStore } from '../stores/session'

const session = useSessionStore()
const loading = ref(false)
const overview = ref({ greenhouses: [], devices: [], activeAlerts: [], currentTelemetry: {} })

const isFreshFarmer = computed(() => session.profile?.username !== 'farmer001')
const statusText = status => ({ RUNNING: '运行中', STOPPED: '已停止', MAINTENANCE: '维护中' }[status] || status)

onMounted(async () => {
  if (isFreshFarmer.value) return
  loading.value = true
  try {
    overview.value = await fetchOverview(1)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.farmer-hero,
.empty-workbench {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}

.eyebrow {
  color: var(--brand);
  font-weight: 900;
}

.farmer-hero h2,
.empty-workbench h3 {
  margin: 8px 0;
  color: #f7fffb;
  font-size: 30px;
}

.farmer-hero p,
.empty-workbench p {
  max-width: 760px;
  color: var(--muted);
  line-height: 1.8;
}

.empty-workbench {
  min-height: 260px;
  background:
    radial-gradient(circle at 12% 20%, rgba(54, 230, 166, 0.14), transparent 34%),
    linear-gradient(145deg, rgba(17, 42, 39, 0.82), rgba(7, 20, 22, 0.76));
}

@media (max-width: 760px) {
  .farmer-hero,
  .empty-workbench {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
