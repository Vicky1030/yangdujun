<template>
  <section class="panel" v-loading="loading">
    <div class="panel-head">
      <div>
        <h2 class="section-title">工业级操作审计日志</h2>
        <p class="muted">按时间倒序展示系统关键操作记录，支持按模块、用户、状态和时间筛选。</p>
      </div>
      <el-button type="primary" plain @click="load">刷新</el-button>
    </div>

    <div class="log-filters">
      <el-input v-model.trim="filters.keyword" clearable placeholder="Trace ID / 接口 / 动作 / 消息" />
      <el-input v-model.trim="filters.module" clearable placeholder="模块，如 AuthController" />
      <el-input v-model.trim="filters.username" clearable placeholder="操作用户" />
      <el-select v-model="filters.success" clearable placeholder="执行状态">
        <el-option label="成功" :value="true" />
        <el-option label="失败" :value="false" />
      </el-select>
      <el-date-picker
        v-model="filters.range"
        type="datetimerange"
        range-separator="至"
        start-placeholder="开始时间"
        end-placeholder="结束时间"
        value-format="YYYY-MM-DD HH:mm:ss"
      />
      <el-button type="primary" @click="search">查询</el-button>
      <el-button @click="resetFilters">重置</el-button>
    </div>

    <el-table :data="rows" style="width: 100%; margin-top: 16px">
      <el-table-column prop="trace_id" label="Trace ID" width="220" />
      <el-table-column prop="username" label="用户" width="120">
        <template #default="{ row }">{{ row.username || 'anonymous' }}</template>
      </el-table-column>
      <el-table-column prop="module_name" label="模块" width="160" />
      <el-table-column prop="action_name" label="动作" width="150" />
      <el-table-column prop="request_uri" label="接口" min-width="220" />
      <el-table-column prop="success" label="成功" width="90">
        <template #default="{ row }">
          <el-tag :type="row.success ? 'success' : 'danger'">{{ row.success ? '是' : '否' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="elapsed_ms" label="耗时/ms" width="110" />
      <el-table-column prop="client_ip" label="IP" width="140" />
      <el-table-column prop="message" label="消息" min-width="180" />
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
import { onMounted, reactive, ref } from 'vue'
import { fetchOperationLogs } from '../services/user'

const loading = ref(false)
const rows = ref([])
const page = ref(1)
const pageSize = 10
const total = ref(0)
const filters = reactive({
  keyword: '',
  module: '',
  username: '',
  success: null,
  range: []
})

const requestParams = () => ({
  page: page.value,
  size: pageSize,
  keyword: filters.keyword || undefined,
  module: filters.module || undefined,
  username: filters.username || undefined,
  success: filters.success ?? undefined,
  startTime: filters.range?.[0],
  endTime: filters.range?.[1]
})

const load = async () => {
  loading.value = true
  try {
    const result = await fetchOperationLogs(requestParams())
    rows.value = result.records || []
    total.value = Number(result.total || 0)
  } finally {
    loading.value = false
  }
}

const search = async () => {
  page.value = 1
  await load()
}

const resetFilters = async () => {
  Object.assign(filters, { keyword: '', module: '', username: '', success: null, range: [] })
  await search()
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

.log-filters {
  display: grid;
  grid-template-columns: minmax(220px, 1.3fr) minmax(180px, 0.9fr) minmax(150px, 0.8fr) 130px minmax(330px, 1.4fr) auto auto;
  gap: 12px;
  margin-top: 18px;
}

.pager {
  display: flex;
  justify-content: center;
  margin-top: 18px;
}

@media (max-width: 1280px) {
  .log-filters {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .panel-head {
    flex-direction: column;
  }

  .log-filters {
    grid-template-columns: 1fr;
  }

  .pager {
    overflow-x: auto;
  }
}
</style>
