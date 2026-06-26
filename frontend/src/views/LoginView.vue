<template>
  <main class="login">
    <section class="login__panel">
      <div class="login__copy">
        <span class="eyebrow">智慧农业管理平台</span>
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

          <el-tab-pane label="注册" name="register">
            <el-form label-position="top" @submit.prevent>
              <el-form-item>
                <el-input v-model.trim="registerForm.username" size="large" placeholder="用户名，不能为 admin" />
              </el-form-item>
              <el-form-item>
                <el-input v-model.trim="registerForm.phone" size="large" placeholder="手机号，作为资料和联系信息" />
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
  width: min(1080px, 100%);
  min-height: 620px;
  grid-template-columns: 1.05fr 0.95fr;
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
