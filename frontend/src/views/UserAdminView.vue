<template>
  <section class="panel" v-loading="loading">
    <h2 class="section-title">农户与账号管理</h2>
    <el-table :data="users" style="width: 100%; margin-top: 16px">
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="display_name" label="昵称" />
      <el-table-column prop="role_code" label="角色" width="120" />
      <el-table-column prop="phone" label="手机号" />
      <el-table-column prop="email" label="邮箱" />
      <el-table-column prop="last_login_ip" label="最近 IP" />
      <el-table-column prop="enabled" label="状态" width="100" />
    </el-table>
  </section>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { fetchUsers } from '../services/user'
const loading = ref(false)
const users = ref([])
onMounted(async () => {
  loading.value = true
  try { users.value = await fetchUsers() } finally { loading.value = false }
})
</script>
