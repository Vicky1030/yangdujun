<template>
  <div class="page" v-loading="loading">
    <div class="farmer-hero panel">
      <div>
        <span class="eyebrow">Farmer Web Console</span>
        <h2>我的大棚工作台</h2>
        <p>查看环境、接收告警、提交反馈和追踪批次记录。</p>
      </div>
      <el-button type="primary" @click="$router.push('/profile')">完善资料</el-button>
    </div>
    <div class="metric-grid">
      <div class="metric-card"><span>温度</span><strong>{{ overview.currentTelemetry?.temperature }}℃</strong></div>
      <div class="metric-card"><span>湿度</span><strong>{{ overview.currentTelemetry?.humidity }}%</strong></div>
      <div class="metric-card"><span>CO₂</span><strong>{{ overview.currentTelemetry?.co2Ppm }}ppm</strong></div>
      <div class="metric-card"><span>未处理告警</span><strong>{{ overview.activeAlerts?.length || 0 }}</strong></div>
    </div>
    <section class="panel">
      <h2 class="section-title">我的设备</h2>
      <el-table :data="overview.devices" style="width: 100%; margin-top: 16px">
        <el-table-column prop="name" label="设备" />
        <el-table-column prop="category" label="类型" />
        <el-table-column prop="status" label="状态" />
        <el-table-column prop="healthScore" label="健康度" />
      </el-table>
    </section>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchOverview } from '../services/greenhouse'
const loading = ref(false)
const overview = ref({})
onMounted(async () => {
  loading.value = true
  try { overview.value = await fetchOverview(1) } finally { loading.value = false }
})
</script>

<style scoped>
.farmer-hero {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #ffffff, #ecf7f0);
}
.eyebrow {
  color: var(--brand);
  font-weight: 800;
}
.farmer-hero h2 {
  margin: 8px 0;
  font-size: 30px;
}
</style>
