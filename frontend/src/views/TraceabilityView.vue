<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2 class="section-title">批次溯源</h2>
          <p class="muted">按时间、批次码和大棚查询生产批次。点击批次卡片可查看区块链式时间流程。</p>
        </div>
      </div>
      <div class="filters">
        <el-input v-model.trim="filters.batchNo" clearable placeholder="批次码" />
        <el-select v-model="filters.greenhouseId" clearable placeholder="大棚">
          <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
        <el-date-picker v-model="dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD" />
        <el-button type="primary" @click="load">查询</el-button>
      </div>
      <div class="batch-grid">
        <article v-for="batch in batches" :key="batch.id" class="batch-card" @click="openDetail(batch)">
          <span>{{ batch.greenhouse_name }}</span>
          <h3>{{ batch.batch_name }}</h3>
          <p>批次码：{{ batch.batch_no }}</p>
          <p>{{ batch.summary }}</p>
          <div><el-tag>{{ statusText(batch.status) }}</el-tag><small>{{ batch.started_at }} 开始</small></div>
        </article>
        <el-empty v-if="!batches.length" description="暂无批次数据" />
      </div>
    </section>

    <el-dialog v-model="detailVisible" title="批次链路详情" width="860px">
      <div v-if="detail.batch" class="batch-detail">
        <div class="detail-head">
          <div>
            <span>{{ detail.batch.greenhouse_name }}</span>
            <h2>{{ detail.batch.batch_name }}</h2>
            <p>批次码：{{ detail.batch.batch_no }} · {{ statusText(detail.batch.status) }}</p>
          </div>
        </div>
        <div class="block-chain">
          <article v-for="event in detail.events" :key="event.id" class="block-card">
            <div class="block-index">{{ event.sort_order }}</div>
            <div>
              <strong>{{ event.event_title }}</strong>
              <p>{{ event.description }}</p>
              <small>{{ formatTime(event.event_time) }} · {{ event.operator || '-' }}</small>
              <code>{{ event.previous_hash || 'GENESIS' }} → {{ event.block_hash || '-' }}</code>
            </div>
            <el-tag :type="event.event_status === 'RUNNING' ? 'warning' : 'success'">{{ event.event_status === 'RUNNING' ? '进行中' : '已完成' }}</el-tag>
          </article>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { fetchBatchDetail, fetchBatches, fetchGreenhouses } from '../services/greenhouse'

const loading = ref(false)
const batches = ref([])
const greenhouses = ref([])
const dateRange = ref([])
const detailVisible = ref(false)
const detail = reactive({ batch: null, events: [] })
const filters = reactive({ batchNo: '', greenhouseId: null })

const statusText = status => ({ RUNNING: '进行中', DONE: '已完成', CLOSED: '已归档' }[status] || status)
const formatTime = value => value ? new Date(value).toLocaleString('zh-CN') : ''

const load = async () => {
  loading.value = true
  try {
    batches.value = await fetchBatches({
      batchNo: filters.batchNo || undefined,
      greenhouseId: filters.greenhouseId || undefined,
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1]
    })
  } finally { loading.value = false }
}

const openDetail = async batch => {
  Object.assign(detail, await fetchBatchDetail(batch.id))
  detailVisible.value = true
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  await load()
})
</script>

<style scoped>
.panel-head, .filters { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
.filters { margin-top: 18px; justify-content: flex-start; }
.filters .el-input, .filters .el-select { max-width: 220px; }
.batch-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; margin-top: 18px; }
.batch-card { padding: 18px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255,255,255,.76); cursor: pointer; transition: transform .18s ease; }
.batch-card:hover { transform: translateY(-2px); border-color: var(--brand); }
.batch-card span, .batch-card p, .batch-card small { color: var(--muted); }
.batch-card h3 { margin: 8px 0; }
.batch-card div { display: flex; justify-content: space-between; align-items: center; gap: 12px; }
.detail-head { padding: 16px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(83,184,106,.1); }
.detail-head h2 { margin: 6px 0; }
.block-chain { display: grid; gap: 14px; margin-top: 18px; }
.block-card { position: relative; display: grid; grid-template-columns: 52px 1fr auto; gap: 14px; align-items: start; padding: 16px; border: 1px solid var(--line); border-radius: var(--radius); background: rgba(255,255,255,.86); }
.block-card::before { content: ""; position: absolute; left: 41px; top: -16px; width: 2px; height: 16px; background: var(--brand); }
.block-card:first-child::before { display: none; }
.block-index { display: grid; width: 38px; height: 38px; place-items: center; border-radius: 50%; background: var(--brand); color: #fff; font-weight: 900; }
.block-card p { margin: 8px 0; color: var(--muted); }
.block-card small { display: block; color: var(--muted); }
.block-card code { display: block; margin-top: 8px; color: #2f6f45; white-space: normal; }
</style>
