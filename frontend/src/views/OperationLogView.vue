<template>
  <section class="panel" v-loading="loading">
    <h2 class="section-title">工业级操作审计日志</h2>
    <el-table :data="rows" style="width: 100%; margin-top: 16px">
      <el-table-column prop="trace_id" label="Trace ID" width="220" />
      <el-table-column prop="module_name" label="模块" width="160" />
      <el-table-column prop="action_name" label="动作" width="150" />
      <el-table-column prop="request_uri" label="接口" />
      <el-table-column prop="success" label="成功" width="90">
        <template #default="{ row }">
          <el-tag :type="row.success ? 'success' : 'danger'">{{ row.success ? '是' : '否' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="elapsed_ms" label="耗时/ms" width="110" />
      <el-table-column prop="client_ip" label="IP" width="140" />
      <el-table-column prop="created_at" label="时间" width="220" />
    </el-table>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchOperationLogs } from '../services/user'

const loading = ref(false)
const rows = ref([])

onMounted(async () => {
  loading.value = true
  try {
    rows.value = await fetchOperationLogs()
  } finally {
    loading.value = false
  }
})
</script>
