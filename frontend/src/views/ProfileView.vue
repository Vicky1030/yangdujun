<template>
  <div class="split-grid">
    <section class="panel">
      <h2 class="section-title">个人中心</h2>
      <div class="profile-head">
        <el-upload :show-file-list="false" :auto-upload="false" accept="image/*" @change="onAvatarChange">
          <el-avatar :size="86" :src="form.avatarUrl">{{ avatarText }}</el-avatar>
        </el-upload>
        <div>
          <strong>{{ titleName }}</strong>
          <p class="muted">IP 方位：{{ ipLocationText }}</p>
        </div>
      </div>
      <el-form label-width="96px" style="margin-top: 18px">
        <el-form-item label="用户名"><el-input v-model="form.username" :disabled="form.username === 'admin'" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="邮箱"><el-input v-model="form.email" /></el-form-item>
        <el-form-item v-if="form.username !== 'admin'" label="昵称"><el-input v-model="form.displayName" /></el-form-item>
        <el-form-item label="性别">
          <el-select v-model="form.gender" style="width: 100%">
            <el-option label="男" value="MALE" />
            <el-option label="女" value="FEMALE" />
            <el-option label="未设置" value="UNKNOWN" />
          </el-select>
        </el-form-item>
        <el-form-item label="个人简介"><el-input v-model="form.bio" type="textarea" :rows="4" /></el-form-item>
        <el-button type="primary" @click="save">保存资料</el-button>
      </el-form>
    </section>

    <section class="panel">
      <h2 class="section-title">问题反馈</h2>
      <el-form style="margin-top: 18px" label-position="top">
        <el-form-item label="问题类型"><el-input v-model="feedback.category" placeholder="功能建议 / 设备异常 / 数据问题" /></el-form-item>
        <el-form-item label="联系方式"><el-input v-model="feedback.contact" /></el-form-item>
        <el-form-item label="反馈内容"><el-input v-model="feedback.content" type="textarea" :rows="7" /></el-form-item>
        <el-button type="primary" @click="submit">提交反馈</el-button>
      </el-form>
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useSessionStore } from '../stores/session'
import { fetchProfile, submitFeedback, updateProfile } from '../services/user'

const session = useSessionStore()
const form = reactive({})
const feedback = reactive({ category: '', contact: '', content: '' })

const avatarText = computed(() => (form.username === 'admin' ? '管' : (form.displayName || form.username || '用').slice(0, 1)))
const titleName = computed(() => form.username === 'admin' ? '管理员' : (form.displayName || form.username || '用户'))
const ipLocationText = computed(() => formatIpLocation(form.realtimeIp || form.lastLoginIp))

const formatIpLocation = ip => {
  if (!ip) return '未知'
  if (ip === '0:0:0:0:0:0:0:1' || ip === '::1' || ip === '127.0.0.1') {
    return '辽宁省沈阳市（本机访问）'
  }
  if (/^(10\.|192\.168\.|172\.(1[6-9]|2\d|3[01])\.)/.test(ip)) {
    return '局域网访问（接入 IP 地址库后显示省市）'
  }
  return `公网 IP：${ip}（接入 IP 地址库后显示省市）`
}

const load = async () => {
  Object.assign(form, await fetchProfile(session.profile.id))
}

const save = async () => {
  if (form.username === 'admin') {
    form.displayName = '管理员'
  }
  const profile = await updateProfile(session.profile.id, form)
  Object.assign(form, profile)
  session.profile = { ...session.profile, ...profile }
  localStorage.setItem('greenhouse_profile', JSON.stringify(session.profile))
  ElMessage.success('资料已保存')
}

const submit = async () => {
  if (!feedback.category) return ElMessage.warning('请填写问题类型')
  if (!feedback.content) return ElMessage.warning('请填写反馈内容')
  await submitFeedback({ ...feedback, userId: session.profile.id })
  feedback.category = ''
  feedback.contact = ''
  feedback.content = ''
  ElMessage.success('反馈已提交')
}

const onAvatarChange = (file) => {
  const reader = new FileReader()
  reader.onload = () => {
    form.avatarUrl = reader.result
  }
  reader.readAsDataURL(file.raw)
}

onMounted(load)
</script>

<style scoped>
.profile-head {
  display: flex;
  gap: 18px;
  align-items: center;
  padding: 18px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255, 255, 255, 0.055);
}

.profile-head strong {
  color: #f7fffb;
  font-size: 20px;
}
</style>
