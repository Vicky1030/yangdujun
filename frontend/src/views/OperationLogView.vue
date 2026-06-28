<template>
  <section class="panel" v-loading="loading">
    <div class="panel-head">
      <div>
        <h2 class="section-title">工业级操作审计日志</h2>
        <p class="muted">按时间倒序展示系统关键操作记录，每页 10 条。</p>
      </div>
      <el-button type="primary" plain @click="load">刷新</el-button>
    </div>

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

    <div class="pager">
      <el-pagination
        v-model:current-page="page"
        :page-size="pageSize"
        :total="total"
        background
        layout="total, prev, pager, next, jumper"
        @current-change="load"
      />
    </div>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchOperationLogs } from '../services/user'

const loading = ref(false)
const rows = ref([])
const page = ref(1)
const pageSize = 10
const total = ref(0)

const load = async () => {
  loading.value = true
  try {
    const result = await fetchOperationLogs({ page: page.value, size: pageSize })
    rows.value = result.records || []
    total.value = Number(result.total || 0)
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.panel-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.pager {
  display: flex;
  justify-content: center;
  margin-top: 18px;
}

@media (max-width: 720px) {
  .panel-head {
    flex-direction: column;
  }

  .pager {
    overflow-x: auto;
  }
}
</style>
