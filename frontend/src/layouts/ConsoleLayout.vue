<template>
  <el-container class="console">
    <el-aside width="248px" class="console__aside">
      <div class="brand">
        <div class="brand__mark">菌</div>
        <div>
          <strong>菌境智联</strong>
          <span>羊肚菌生态调控平台</span>
        </div>
      </div>

      <el-menu router :default-active="$route.path" class="nav">
        <el-menu-item index="/">
          <el-icon><DataAnalysis /></el-icon>
          <span>管理总览</span>
        </el-menu-item>
        <el-menu-item index="/devices">
          <el-icon><Operation /></el-icon>
          <span>设备管理</span>
        </el-menu-item>
        <el-menu-item index="/alerts">
          <el-icon><Warning /></el-icon>
          <span>告警中心</span>
        </el-menu-item>
        <el-menu-item index="/traceability">
          <el-icon><Tickets /></el-icon>
          <span>批次溯源</span>
        </el-menu-item>
        <el-menu-item index="/profile">
          <el-icon><User /></el-icon>
          <span>个人中心</span>
        </el-menu-item>
        <template v-if="session.profile?.role === 'ADMIN'">
          <el-menu-item index="/users">
            <el-icon><UserFilled /></el-icon>
            <span>农户管理</span>
          </el-menu-item>
          <el-menu-item index="/feedback">
            <el-icon><ChatDotRound /></el-icon>
            <span>反馈处理</span>
          </el-menu-item>
          <el-menu-item index="/logs">
            <el-icon><Document /></el-icon>
            <span>操作审计</span>
          </el-menu-item>
        </template>
        <el-menu-item v-else index="/farmer">
          <el-icon><House /></el-icon>
          <span>农户工作台</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="console__header">
        <div>
          <p>{{ currentDate }}</p>
          <h1>{{ $route.meta.title || '智慧大棚控制台' }}</h1>
        </div>
        <div class="header-actions">
          <span class="system-pill"><span class="status-dot" />物联感知在线</span>
          <el-dropdown>
            <span class="operator">{{ operatorName }}</span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="console__main">
        <RouterView />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { ChatDotRound, DataAnalysis, Document, House, Operation, Tickets, User, UserFilled, Warning } from '@element-plus/icons-vue'
import { useSessionStore } from '../stores/session'

const router = useRouter()
const session = useSessionStore()
const currentDate = computed(() => new Date().toLocaleString('zh-CN'))
const operatorName = computed(() => session.profile?.username === 'admin' ? '管理员' : (session.profile?.displayName || session.profile?.username || '用户'))

const logout = () => {
  session.signOut()
  router.push('/login')
}
</script>

<style scoped>
.console {
  min-height: 100vh;
}

.console__aside {
  position: relative;
  z-index: 2;
  border-right: 1px solid var(--line);
  background: linear-gradient(180deg, rgba(8, 23, 21, 0.96), rgba(6, 17, 20, 0.92));
  color: #fff;
  box-shadow: 22px 0 70px rgba(0, 0, 0, 0.24);
  backdrop-filter: blur(20px);
}

.brand {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 24px 20px;
}

.brand__mark {
  display: grid;
  width: 44px;
  height: 44px;
  place-items: center;
  border: 1px solid rgba(54, 230, 166, 0.45);
  border-radius: 8px;
  background: radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.36), transparent 28%), linear-gradient(135deg, var(--brand), var(--cyan));
  color: #031412;
  font-weight: 900;
  box-shadow: 0 0 24px rgba(54, 230, 166, 0.28);
}

.brand strong,
.brand span {
  display: block;
}

.brand strong {
  color: #f5fffb;
  font-size: 18px;
}

.brand span {
  margin-top: 4px;
  color: var(--muted);
  font-size: 12px;
}

.nav {
  border: 0;
  background: transparent;
}

.nav :deep(.el-menu-item) {
  height: 46px;
  margin: 4px 12px;
  border-radius: var(--radius);
  color: #a8c8bd;
}

.nav :deep(.el-menu-item.is-active),
.nav :deep(.el-menu-item:hover) {
  background: linear-gradient(90deg, rgba(54, 230, 166, 0.18), rgba(68, 217, 255, 0.08));
  color: #f7fffb;
  box-shadow: inset 3px 0 0 var(--brand);
}

.console__header {
  display: flex;
  height: 84px;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--line);
  background: rgba(6, 18, 18, 0.62);
  backdrop-filter: blur(18px);
}

.console__header p,
.console__header h1 {
  margin: 0;
}

.console__header p {
  color: var(--muted);
  font-size: 13px;
}

.console__header h1 {
  margin-top: 4px;
  color: #f4fffb;
  font-size: 22px;
}

.header-actions {
  display: flex;
  gap: 14px;
  align-items: center;
}

.system-pill,
.operator {
  display: inline-flex;
  align-items: center;
  border: 1px solid var(--line);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.07);
  color: #dffbf2;
}

.system-pill {
  gap: 6px;
  padding: 8px 12px;
  font-size: 13px;
}

.operator {
  cursor: pointer;
  padding: 9px 14px;
  font-weight: 800;
}

.console__main {
  padding: 22px;
}
</style>
