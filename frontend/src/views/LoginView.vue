<template>
  <main class="login">
    <section class="login__panel">
      <div class="login__copy">
        <span class="eyebrow">MorelOps Platform</span>
        <h1>智慧羊肚菌大棚管理系统</h1>
        <p>面向管理员与农户的环境监测、设备联动、告警审计、批次溯源与问题反馈平台。</p>
      </div>

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

          <el-tab-pane label="手机号登录" name="phone">
            <el-form label-position="top" @submit.prevent>
              <el-form-item>
                <el-input v-model.trim="phoneForm.phone" size="large" placeholder="手机号" />
              </el-form-item>
              <SlideVerify v-model="phoneSliderPassed" @passed="phoneForm.captchaToken = 'slider-ok'" />
              <el-form-item>
                <el-input v-model.trim="phoneForm.verificationCode" size="large" placeholder="验证码">
                  <template #append>
                    <el-button :disabled="!canSendPhoneCode" :loading="codeLoading.phone" @click="sendPhoneCode">发送</el-button>
                  </template>
                </el-input>
              </el-form-item>
              <AgreementCheck v-model="loginAgreed" @open="openPolicy" />
              <el-button type="primary" size="large" :loading="loading" @click="submitPhoneLogin">快捷登录</el-button>
            </el-form>
          </el-tab-pane>

          <el-tab-pane label="注册" name="register">
            <el-form label-position="top" @submit.prevent>
              <el-form-item>
                <el-input v-model.trim="registerForm.username" size="large" placeholder="用户名，不能为 admin" />
              </el-form-item>
              <el-form-item>
                <el-input v-model.trim="registerForm.phone" size="large" placeholder="手机号" />
              </el-form-item>
              <el-form-item>
                <el-input v-model.trim="registerForm.email" size="large" placeholder="邮箱，填写后验证码优先发到邮箱" />
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
                <el-input v-model.trim="registerForm.verificationCode" size="large" placeholder="验证码">
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
        <el-form-item label="手机号或邮箱">
          <el-input v-model.trim="forgotForm.receiver" size="large" placeholder="请输入绑定的手机号或邮箱" />
        </el-form-item>
        <el-form-item label="验证码">
          <el-input v-model.trim="forgotForm.verificationCode" size="large" placeholder="验证码">
            <template #append>
              <el-button :disabled="!forgotForm.receiver" :loading="codeLoading.reset" @click="sendResetCode">发送</el-button>
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

const SlideVerify = defineComponent({
  props: { modelValue: Boolean },
  emits: ['update:modelValue', 'passed'],
  setup(props, { emit }) {
    let dragging = false
    const percent = ref(props.modelValue ? 100 : 0)

    const moveTo = event => {
      if (!dragging || props.modelValue) return
      const rect = event.currentTarget.getBoundingClientRect()
      const clientX = event.touches?.[0]?.clientX ?? event.clientX
      percent.value = Math.max(0, Math.min(100, ((clientX - rect.left) / rect.width) * 100))
      if (percent.value > 88) {
        percent.value = 100
        dragging = false
        emit('update:modelValue', true)
        emit('passed')
        ElMessage.success('人机验证通过')
      }
    }

    const start = () => {
      if (!props.modelValue) dragging = true
    }
    const end = () => {
      if (!props.modelValue) percent.value = 0
      dragging = false
    }

    return () => h('div', {
      class: ['slide-verify', props.modelValue ? 'is-passed' : ''],
      onMousedown: start,
      onMousemove: moveTo,
      onMouseup: end,
      onMouseleave: end,
      onTouchstart: start,
      onTouchmove: moveTo,
      onTouchend: end
    }, [
      h('div', { class: 'slide-verify__track' }, [
        h('div', { class: 'slide-verify__fill', style: { width: `${percent.value}%` } }),
        h('div', { class: 'slide-verify__text' }, props.modelValue ? '验证通过' : '按住滑块拖动到最右侧'),
        h('div', { class: 'slide-verify__thumb', style: { left: `calc(${percent.value}% - 22px)` } }, '›')
      ])
    ])
  }
})

const router = useRouter()
const session = useSessionStore()
const mode = ref('password')
const loading = ref(false)
const loginAgreed = ref(false)
const registerAgreed = ref(false)
const policyVisible = ref(false)
const forgotVisible = ref(false)
const phoneSliderPassed = ref(false)
const policy = reactive({ title: '', content: '' })
const codeLoading = reactive({ phone: false, register: false, reset: false })
const loginForm = reactive({ username: '', password: '' })
const phoneForm = reactive({ phone: '', verificationCode: '', captchaToken: '' })
const registerForm = reactive({ username: '', phone: '', email: '', password: '', confirmPassword: '', verificationCode: '' })
const forgotForm = reactive({ receiver: '', verificationCode: '', newPassword: '', confirmPassword: '' })

const canSendPhoneCode = computed(() => /^1\d{10}$/.test(phoneForm.phone) && phoneSliderPassed.value)
const canSendRegisterCode = computed(() => /^1\d{10}$/.test(registerForm.phone) || /.+@.+\..+/.test(registerForm.email))

const passwordStrength = computed(() => {
  const password = registerForm.password
  let score = 0
  if (password.length >= 8) score += 1
  if (/[A-Z]/.test(password) && /[a-z]/.test(password)) score += 1
  if (/\d/.test(password) && /[^A-Za-z0-9]/.test(password)) score += 1
  return score >= 3 ? '强' : score === 2 ? '中等' : '弱'
})
const strengthType = computed(() => passwordStrength.value === '强' ? 'success' : passwordStrength.value === '中等' ? 'warning' : 'danger')

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

const submitPhoneLogin = async () => {
  if (!phoneForm.phone) return ElMessage.warning('手机号不能为空')
  if (!phoneSliderPassed.value) return ElMessage.warning('请先完成滑块验证')
  if (!phoneForm.verificationCode) return ElMessage.warning('验证码不能为空')
  if (!requireAgreement(loginAgreed.value)) return
  loading.value = true
  try {
    await session.signInByPhone(phoneForm)
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
  if (!forgotForm.receiver) return ElMessage.warning('手机号或邮箱不能为空')
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

const sendRegisterCode = () => requestCode(registerForm.email || registerForm.phone, 'REGISTER', '', 'register')
const sendPhoneCode = () => requestCode(phoneForm.phone, 'PHONE_LOGIN', phoneForm.captchaToken, 'phone')
const sendResetCode = () => requestCode(forgotForm.receiver, 'RESET_PASSWORD', '', 'reset')

const requestCode = async (receiver, scene, captchaToken = '', key) => {
  if (!receiver) return ElMessage.warning('请先填写接收手机号或邮箱')
  codeLoading[key] = true
  try {
    const res = await sendCode({ receiver, scene, captchaToken })
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
  display: grid;
  min-height: 100vh;
  place-items: center;
  padding: 48px;
  background:
    linear-gradient(115deg, rgba(13, 31, 24, 0.95), rgba(28, 111, 78, 0.72)),
    url('/greenhouse-bg.svg');
}

.login__panel {
  display: grid;
  width: min(1160px, 100%);
  min-height: 650px;
  grid-template-columns: 1.08fr 0.92fr;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.28);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.96);
  box-shadow: 0 32px 80px rgba(0, 0, 0, 0.28);
}

.login__copy {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 54px;
  background:
    linear-gradient(155deg, rgba(16, 37, 28, 0.95), rgba(31, 122, 85, 0.82)),
    radial-gradient(circle at 24% 18%, rgba(223, 180, 86, 0.28), transparent 32%);
  color: #fff;
}

.eyebrow {
  color: #dfb456;
  font-weight: 800;
}

.login__copy h1 {
  margin: 18px 0;
  font-size: 46px;
  line-height: 1.12;
}

.login__copy p {
  max-width: 520px;
  color: #d7e7df;
  font-size: 17px;
}

.login__form {
  align-self: center;
  padding: 44px;
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
}

.strength {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: -8px 0 12px;
}

.slide-verify {
  margin-bottom: 18px;
  user-select: none;
}

.slide-verify__track {
  position: relative;
  height: 44px;
  overflow: hidden;
  border: 1px solid #d9e5df;
  border-radius: 8px;
  background: #f5f8f6;
}

.slide-verify__fill {
  position: absolute;
  inset: 0 auto 0 0;
  background: linear-gradient(90deg, #b9e6cf, #43a36f);
  transition: width 0.1s ease;
}

.slide-verify__text {
  position: absolute;
  inset: 0;
  display: grid;
  place-items: center;
  color: #476056;
  font-size: 14px;
  font-weight: 700;
}

.slide-verify__thumb {
  position: absolute;
  top: 3px;
  display: grid;
  width: 38px;
  height: 38px;
  place-items: center;
  border-radius: 7px;
  background: #fff;
  box-shadow: 0 8px 18px rgba(20, 77, 51, 0.22);
  color: #1f7a55;
  font-size: 28px;
  font-weight: 900;
  transition: left 0.1s ease;
}

.slide-verify.is-passed .slide-verify__text {
  color: #fff;
}

.policy-content {
  white-space: pre-line;
  line-height: 1.9;
  color: #4a5f55;
}

@media (max-width: 860px) {
  .login {
    padding: 22px;
  }

  .login__panel {
    grid-template-columns: 1fr;
  }

  .login__copy {
    min-height: 240px;
    padding: 32px;
  }

  .login__copy h1 {
    font-size: 34px;
  }

  .login__form {
    padding: 28px;
  }
}
</style>
