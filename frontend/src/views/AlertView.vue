<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">告警中心</h2>
          <p class="muted">集中查看各大棚和设备发出的告警，便于管理员排查处理。</p>
        </div>
        <div class="head-actions">
          <el-select v-model="greenhouseId" clearable placeholder="全部大棚" style="width: 220px" @change="loadAlerts">
            <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
          <el-select v-model="statusFilter" clearable placeholder="全部状态" style="width: 160px">
            <el-option label="待处理" value="OPEN" />
            <el-option label="已确认" value="ACKNOWLEDGED" />
            <el-option label="已解决" value="RESOLVED" />
          </el-select>
        </div>
      </div>

      <el-table :data="filteredAlerts" style="width: 100%; margin-top: 16px">
        <el-table-column prop="occurredAt" label="告警时间" width="180">
          <template #default="{ row }">{{ formatTime(row.occurredAt) }}</template>
        </el-table-column>
        <el-table-column prop="greenhouseName" label="发出告警的大棚" min-width="180" />
        <el-table-column prop="deviceName" label="发出告警的设备" min-width="170">
          <template #default="{ row }">{{ row.deviceName || '大棚环境监测' }}</template>
        </el-table-column>
        <el-table-column prop="title" label="告警信息" min-width="220" />
        <el-table-column prop="level" label="告警级别" width="120">
          <template #default="{ row }">
            <el-tag :type="levelTag(row.level)">{{ levelText(row.level) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="告警状态" width="120">
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
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { fetchAlertDetails, fetchGreenhouses } from '../services/greenhouse'

const route = useRoute()
const loading = ref(false)
const greenhouseId = ref(null)
const statusFilter = ref(route.query.status || '')
const greenhouses = ref([])
const alerts = ref([])

const filteredAlerts = computed(() => statusFilter.value ? alerts.value.filter(item => item.status === statusFilter.value) : alerts.value)
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
.panel-head,
.head-actions {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

@media (max-width: 760px) {
  .panel-head,
  .head-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
