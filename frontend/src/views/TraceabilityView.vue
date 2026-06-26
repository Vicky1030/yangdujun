<template>
  <div class="page" v-loading="loading">
    <section class="panel">
      <h2 class="section-title">批次溯源链路</h2>
      <el-timeline style="margin-top: 24px">
        <el-timeline-item
          v-for="item in records"
          :key="item.id"
          :timestamp="item.operationDate"
          placement="top"
        >
          <el-card>
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
