<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <h2 class="section-title">批次溯源链路</h2>
      <p class="muted">记录羊肚菌生产批次从菌包、温湿度管理到采收的关键操作。</p>
      <el-timeline style="margin-top: 24px">
        <el-timeline-item
          v-for="item in records"
          :key="item.id"
          :timestamp="item.operationDate"
          placement="top"
        >
          <el-card class="trace-card">
            <strong>{{ item.operation }}</strong>
            <p class="muted">批次：{{ item.batchNo }} / 操作人：{{ item.operator }}</p>
            <p>{{ item.note }}</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </section>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchTraceability } from '../services/greenhouse'

const loading = ref(false)
const records = ref([])

onMounted(async () => {
  loading.value = true
  try {
    records.value = await fetchTraceability(1)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.trace-card {
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255, 255, 255, 0.06);
  color: var(--ink);
}
</style>
