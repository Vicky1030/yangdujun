<template>
  <main class="login" :class="{ 'login--ready': panelVisible }">
    <video
      ref="introVideo"
      class="login__video"
      src="/assets/morel-login-intro.mp4"
      autoplay
      muted
      playsinline
      preload="auto"
      @ended="showPanel(mode)"
    />

    <div class="login__veil" />

    <div class="brand-title" :class="{ 'brand-title--visible': panelVisible }">
      <span>智慧农业 · IoT · AI 调控</span>
      <h1>菌境智联 · 羊肚菌智慧生态调控系统</h1>
    </div>

    <div class="intro-actions" :class="{ 'intro-actions--hidden': panelVisible }">
      <el-button @click="showPanel('password')">登录</el-button>
      <el-button type="primary" @click="showPanel('register')">注册</el-button>
    </div>

    <section class="login__panel">
      <div class="login__form">
        <el-tabs v-model="mode" stretch>
          <el-tab-pane label="账号登录" name="password">
            <el-form label-position="top" @submit.prevent>
              <el-form-item>
                <el-input v-model.trim="loginForm.username" size="large" placeholder="用户名，如 admin / farmer001" />
              </el-form-item>
              <el-form-item>
                <el-input v-model="loginForm.password" size="large" type="password" placeholder="密码" show-password />
              </el-form-item>
              <AgreementCheck v-model="loginAgreed" @open="openPolicy" />
              <el-button type="primary" size="large" :loading="loading" @click="submitLogin">进入系统</el-button>
              <el-button class="forgot-link" link @click="forgotVisible = true">忘记密码？</el-button>
            </el-form>
          </el-tab-pane>

          <el-tab-pane label="注册" name="register">
            <el-form label-position="top" @submit.prevent>
              <el-form-item>
                <el-input v-model.trim="registerForm.username" size="large" placeholder="用户名，不能为 admin" />
              </el-form-item>
              <el-form-item>
                <el-input v-model.trim="registerForm.phone" size="large" placeholder="手机号，用于资料和联系信息" />
              </el-form-item>
              <el-form-item>
                <el-input v-model.trim="registerForm.email" size="large" placeholder="邮箱，验证码将发送到这里" />
              </el-form-item>
              <el-form-item>
                <el-input v-model="registerForm.password" size="large" type="password" placeholder="密码" show-password />
              </el-form-item>
              <div class="strength">
                <span>密码强度</span>
                <el-tag :type="strengthType">{{ passwordStrength }}</el-tag>
              </div>
              <el-form-item>
                <el-input v-model="registerForm.confirmPassword" size="large" type="password" placeholder="再次确认密码" show-password />
              </el-form-item>
              <el-form-item>
                <el-input v-model.trim="registerForm.verificationCode" size="large" placeholder="邮箱验证码">
                  <template #append>
                    <el-button :disabled="!canSendRegisterCode" :loading="codeLoading.register" @click="sendRegisterCode">发送</el-button>
                  </template>
                </el-input>
              </el-form-item>
              <AgreementCheck v-model="registerAgreed" @open="openPolicy" />
              <el-button type="primary" size="large" :loading="loading" @click="submitRegister">注册并登录</el-button>
            </el-form>
          </el-tab-pane>
        </el-tabs>
      </div>
    </section>

    <el-dialog v-model="policyVisible" :title="policy.title" width="620px">
      <div class="policy-content">{{ policy.content }}</div>
    </el-dialog>

    <el-dialog v-model="forgotVisible" title="重置密码" width="520px">
      <el-form label-position="top" @submit.prevent>
        <el-form-item label="邮箱">
          <el-input v-model.trim="forgotForm.receiver" size="large" placeholder="请输入绑定的邮箱" />
        </el-form-item>
        <el-form-item label="邮箱验证码">
          <el-input v-model.trim="forgotForm.verificationCode" size="large" placeholder="邮箱验证码">
            <template #append>
              <el-button :disabled="!canSendResetCode" :loading="codeLoading.reset" @click="sendResetCode">发送</el-button>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="forgotForm.newPassword" size="large" type="password" placeholder="新密码" show-password />
        </el-form-item>
        <el-form-item label="确认新密码">
          <el-input v-model="forgotForm.confirmPassword" size="large" type="password" placeholder="确认新密码" show-password />
        </el-form-item>
        <el-button type="primary" size="large" :loading="loading" @click="submitReset">确认重置</el-button>
      </el-form>
    </el-dialog>
  </main>
</template>

<script setup>
import { computed, defineComponent, h, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElButton, ElCheckbox, ElMessage } from 'element-plus'
import { fetchPolicy, resetPassword, sendCode } from '../services/auth'
import { useSessionStore } from '../stores/session'

const AgreementCheck = defineComponent({
  props: { modelValue: Boolean },
  emits: ['update:modelValue', 'open'],
  setup(props, { emit }) {
    return () => h('div', { class: 'agreement' }, [
      h(ElCheckbox, {
        modelValue: props.modelValue,
        'onUpdate:modelValue': value => emit('update:modelValue', value)
      }, () => '我已阅读并同意'),
      h(ElButton, { link: true, type: 'primary', onClick: () => emit('open', 'privacy') }, () => '隐私政策'),
      h('span', '和'),
      h(ElButton, { link: true, type: 'primary', onClick: () => emit('open', 'terms') }, () => '服务条款')
    ])
  }
})

const router = useRouter()
const session = useSessionStore()
const introVideo = ref(null)
const panelVisible = ref(false)
const mode = ref('password')
const loading = ref(false)
const loginAgreed = ref(false)
const registerAgreed = ref(false)
const policyVisible = ref(false)
const forgotVisible = ref(false)
const policy = reactive({ title: '', content: '' })
const codeLoading = reactive({ register: false, reset: false })
const loginForm = reactive({ username: '', password: '' })
const registerForm = reactive({ username: '', phone: '', email: '', password: '', confirmPassword: '', verificationCode: '' })
const forgotForm = reactive({ receiver: '', verificationCode: '', newPassword: '', confirmPassword: '' })

const canSendRegisterCode = computed(() => /.+@.+\..+/.test(registerForm.email))
const canSendResetCode = computed(() => /.+@.+\..+/.test(forgotForm.receiver))

const passwordStrength = computed(() => {
  const password = registerForm.password
  let score = 0
  if (password.length >= 8) score += 1
  if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score += 1
  if (/\d/.test(password) && /[^A-Za-z0-9]/.test(password)) score += 1
  return score >= 3 ? '强' : score === 2 ? '中等' : '弱'
})
const strengthType = computed(() => passwordStrength.value === '强' ? 'success' : passwordStrength.value === '中等' ? 'warning' : 'danger')

const showPanel = (target = 'password') => {
  mode.value = target
  panelVisible.value = true
  freezeVideoAtFinalFrame()
}

const freezeVideoAtFinalFrame = () => {
  const video = introVideo.value
  if (!video) return
  const freeze = () => {
    if (!Number.isFinite(video.duration) || video.duration <= 0) return
    video.currentTime = Math.max(video.duration - 0.08, 0)
    video.pause()
  }
  if (Number.isFinite(video.duration) && video.duration > 0) {
    freeze()
  } else {
    video.addEventListener('loadedmetadata', freeze, { once: true })
  }
}

const requireAgreement = agreed => {
  if (!agreed) {
    ElMessage.warning('请先阅读并同意隐私政策和服务条款')
    return false
  }
  return true
}

const submitLogin = async () => {
  if (!loginForm.username) return ElMessage.warning('用户名不能为空')
  if (!loginForm.password) return ElMessage.warning('密码不能为空')
  if (!requireAgreement(loginAgreed.value)) return
  loading.value = true
  try {
    await session.signIn(loginForm)
    ElMessage.success('登录成功')
    router.replace(session.profile?.role === 'FARMER' ? '/farmer' : '/')
  } finally {
    loading.value = false
  }
}

const submitRegister = async () => {
  if (!registerForm.username) return ElMessage.warning('用户名不能为空')
  if (registerForm.username.toLowerCase() === 'admin') return ElMessage.warning('admin 是系统保留用户名')
  if (!registerForm.phone) return ElMessage.warning('手机号不能为空')
  if (!registerForm.email) return ElMessage.warning('邮箱不能为空')
  if (!registerForm.password) return ElMessage.warning('密码不能为空')
  if (registerForm.password !== registerForm.confirmPassword) return ElMessage.warning('两次输入的密码不一致')
  if (!registerForm.verificationCode) return ElMessage.warning('验证码不能为空')
  if (!requireAgreement(registerAgreed.value)) return
  loading.value = true
  try {
    await session.signUp(registerForm)
    ElMessage.success('注册成功')
    router.replace('/farmer')
  } finally {
    loading.value = false
  }
}

const submitReset = async () => {
  if (!forgotForm.receiver) return ElMessage.warning('邮箱不能为空')
  if (!forgotForm.verificationCode) return ElMessage.warning('验证码不能为空')
  if (!forgotForm.newPassword) return ElMessage.warning('新密码不能为空')
  if (forgotForm.newPassword !== forgotForm.confirmPassword) return ElMessage.warning('两次输入的密码不一致')
  loading.value = true
  try {
    await resetPassword(forgotForm)
    ElMessage.success('密码已重置，请重新登录')
    forgotVisible.value = false
  } finally {
    loading.value = false
  }
}

const sendRegisterCode = () => requestCode(registerForm.email, 'REGISTER', 'register')
const sendResetCode = () => requestCode(forgotForm.receiver, 'RESET_PASSWORD', 'reset')

const requestCode = async (receiver, scene, key) => {
  if (!/.+@.+\..+/.test(receiver)) return ElMessage.warning('请先填写正确的邮箱地址')
  codeLoading[key] = true
  try {
    const res = await sendCode({ receiver, scene })
    const devText = res.devCode ? `，开发验证码：${res.devCode}` : ''
    ElMessage.success(`${res.message}${devText}`)
  } finally {
    codeLoading[key] = false
  }
}

const openPolicy = async (type) => {
  Object.assign(policy, await fetchPolicy(type))
  policyVisible.value = true
}
</script>

<style scoped>
.login {
  position: relative;
  display: grid;
  min-height: 100vh;
  place-items: center;
  overflow: hidden;
  background: #030908;
}

.login__video {
  position: fixed;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  filter: saturate(1.06) contrast(1.04);
  transform: scale(1.02);
  transition: width 780ms cubic-bezier(.2, .8, .2, 1), height 780ms cubic-bezier(.2, .8, .2, 1), inset 780ms cubic-bezier(.2, .8, .2, 1), border-radius 780ms cubic-bezier(.2, .8, .2, 1), transform 780ms cubic-bezier(.2, .8, .2, 1), filter 780ms ease;
}

.login__veil {
  position: fixed;
  inset: 0;
  pointer-events: none;
  background:
    radial-gradient(circle at 26% 34%, transparent 0 24%, rgba(2, 8, 8, 0.2) 42%, rgba(2, 8, 8, 0.8) 100%),
    linear-gradient(90deg, rgba(2, 8, 8, 0.12), rgba(2, 8, 8, 0.58));
  transition: opacity 620ms ease;
}

.brand-title {
  position: fixed;
  z-index: 3;
  top: clamp(42px, 7vh, 86px);
  left: clamp(44px, 6vw, 118px);
  width: min(430px, 34vw);
  pointer-events: none;
  opacity: 0;
  transform: translateY(10px);
  transition: opacity 420ms ease 160ms, transform 420ms ease 160ms;
}

.brand-title--visible {
  opacity: 1;
  transform: translateY(0);
}

.brand-title span {
  display: block;
  margin-bottom: 12px;
  color: var(--brand);
  font-size: 18px;
  font-weight: 900;
  text-shadow: 0 8px 26px rgba(0, 0, 0, 0.8);
}

.brand-title h1 {
  margin: 0;
  color: #f7fffb;
  font-size: clamp(30px, 3vw, 48px);
  line-height: 1.14;
  letter-spacing: 0;
  text-shadow: 0 10px 34px rgba(0, 0, 0, 0.86);
}

.intro-actions {
  position: fixed;
  z-index: 4;
  top: 30px;
  right: 34px;
  display: flex;
  gap: 12px;
  transition: opacity 260ms ease, transform 260ms ease;
}

.intro-actions--hidden {
  opacity: 0;
  transform: translateY(-8px);
  pointer-events: none;
}

.login__panel {
  position: relative;
  z-index: 3;
  width: min(580px, calc(100vw - 80px));
  min-height: 490px;
  margin-left: clamp(760px, 58vw, 980px);
  overflow: hidden;
  border: 1px solid rgba(140, 255, 214, 0.22);
  border-radius: var(--radius);
  background: rgba(6, 19, 19, 0.86);
  box-shadow: 0 28px 90px rgba(0, 0, 0, 0.46);
  backdrop-filter: blur(22px);
  opacity: 0;
  transform: translateY(12px) scale(0.985);
  pointer-events: none;
  transition: opacity 520ms ease 120ms, transform 520ms ease 120ms;
}

.login--ready .login__panel {
  opacity: 1;
  transform: translateY(0) scale(1);
  pointer-events: auto;
}

.login--ready .login__video {
  inset: 0;
  width: 100%;
  height: 100%;
  min-height: 0;
  object-position: center center;
  border-radius: 0;
  filter: saturate(1.12) contrast(1.06) brightness(0.9);
  transform: scale(1.02);
}

.login--ready .login__veil {
  opacity: 0.22;
}

.login__form {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 46px 48px;
  background: rgba(7, 20, 20, 0.82);
}

.login__form :deep(.el-tabs) {
  width: min(100%, 560px);
}

.login__form :deep(.el-tabs__item) {
  color: var(--muted);
  font-weight: 800;
}

.login__form :deep(.el-tabs__item.is-active) {
  color: var(--brand);
}

.login__form .el-button:not(.is-link),
.el-dialog .el-button:not(.is-link) {
  width: 100%;
}

.forgot-link {
  margin-top: 12px;
}

.agreement {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 4px;
  margin: 4px 0 18px;
  color: var(--muted);
}

.strength {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: -8px 0 12px;
  color: var(--muted);
}

.policy-content {
  white-space: pre-line;
  line-height: 1.9;
  color: #d9f7ee;
}

@media (max-width: 980px) {
  .brand-title {
    top: 28px;
    left: 24px;
    width: min(420px, calc(100vw - 48px));
  }

  .brand-title span {
    font-size: 14px;
  }

  .brand-title h1 {
    font-size: 26px;
  }

  .login__panel {
    width: min(92vw, 640px);
    height: auto;
    min-height: 0;
    margin: 0;
  }

  .login--ready .login__video {
    inset: 0;
    width: 100%;
    height: 100%;
    border-radius: 0;
  }

  .login__form {
    padding: 30px;
  }
}
</style>
