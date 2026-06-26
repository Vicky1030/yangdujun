<template>
  <el-container class="console">
    <el-aside width="248px" class="console__aside">
      <div class="brand">
        <div class="brand__mark">菌</div>
        <div>
          <strong>智慧大棚管理平台</strong>
          <span>羊肚菌生产与设备协同</span>
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
  border-right: 1px solid var(--line);
  background: #10251c;
  color: #fff;
}

.brand {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 24px 20px;
}

.brand__mark {
  display: grid;
  width: 42px;
  height: 42px;
  place-items: center;
  border-radius: 8px;
  background: #d9a441;
  color: #10251c;
  font-weight: 900;
}

.brand strong,
.brand span {
  display: block;
}

.brand span {
  margin-top: 4px;
  color: #b6c7bf;
  font-size: 12px;
}

.nav {
  border: 0;
  background: transparent;
}

.nav :deep(.el-menu-item) {
  color: #b6c7bf;
}

.nav :deep(.el-menu-item.is-active),
.nav :deep(.el-menu-item:hover) {
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}

.console__header {
  display: flex;
  height: 84px;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--line);
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(14px);
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
  font-size: 22px;
}

.header-actions {
  display: flex;
  gap: 16px;
  align-items: center;
}

.operator {
  cursor: pointer;
  font-weight: 700;
}

.console__main {
  padding: 22px;
}
</style>
