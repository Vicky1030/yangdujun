<template>
  <section class="panel" v-loading="loading">
    <h2 class="section-title">问题反馈处理</h2>
    <el-table :data="rows" style="width: 100%; margin-top: 16px">
      <el-table-column prop="category" label="类型" width="160" />
      <el-table-column prop="content" label="内容" />
      <el-table-column prop="contact" label="联系方式" width="180" />
      <el-table-column prop="status" label="状态" width="120" />
      <el-table-column prop="created_at" label="提交时间" width="220" />
    </el-table>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchFeedbacks } from '../services/user'
const loading = ref(false)
const rows = ref([])
onMounted(async () => {
  loading.value = true
  try { rows.value = await fetchFeedbacks() } finally { loading.value = false }
})
</script>
