<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">告警中心</h2>
          <p class="muted">集中查看各大棚和设备发出的告警，便于管理员排查处理。</p>
        </div>
        <el-select v-model="greenhouseId" clearable placeholder="全部大棚" style="width: 260px" @change="loadAlerts">
          <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </div>

      <el-table :data="alerts" style="width: 100%; margin-top: 16px">
        <el-table-column prop="occurredAt" label="告警时间" width="180">
          <template #default="{ row }">{{ formatTime(row.occurredAt) }}</template>
        </el-table-column>
        <el-table-column prop="greenhouseName" label="告警大棚" min-width="180" />
        <el-table-column prop="deviceName" label="告警设备" min-width="160">
          <template #default="{ row }">{{ row.deviceName || '大棚环境监测' }}</template>
        </el-table-column>
        <el-table-column prop="title" label="告警信息" min-width="220" />
        <el-table-column prop="level" label="级别" width="120">
          <template #default="{ row }">
            <el-tag :type="levelTag(row.level)">{{ levelText(row.level) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="120">
          <template #default="{ row }">
            <el-tag :type="statusTag(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="260" />
      </el-table>
    </section>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchAlertDetails, fetchGreenhouses } from '../services/greenhouse'

const loading = ref(false)
const greenhouseId = ref(null)
const greenhouses = ref([])
const alerts = ref([])

const levelText = level => ({ CRITICAL: '严重', WARNING: '警告', INFO: '提示' }[level] || level)
const levelTag = level => level === 'CRITICAL' ? 'danger' : level === 'WARNING' ? 'warning' : 'info'
const statusText = status => ({ OPEN: '待处理', ACKNOWLEDGED: '已确认', RESOLVED: '已解决' }[status] || status)
const statusTag = status => status === 'RESOLVED' ? 'success' : status === 'ACKNOWLEDGED' ? 'warning' : 'danger'
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN') : '-'

const loadAlerts = async () => {
  loading.value = true
  try {
    alerts.value = await fetchAlertDetails(greenhouseId.value)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  await loadAlerts()
})
</script>

<style scoped>
.panel-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

@media (max-width: 760px) {
  .panel-head {
    flex-direction: column;
  }
}
</style>
