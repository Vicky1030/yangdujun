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
        <el-menu-item v-if="isAdmin" index="/">
          <el-icon><DataAnalysis /></el-icon>
          <span>管理总览</span>
        </el-menu-item>
        <el-menu-item v-else index="/farmer">
          <el-icon><House /></el-icon>
          <span>农户工作台</span>
        </el-menu-item>
        <el-menu-item index="/devices">
          <el-icon><Operation /></el-icon>
          <span>设备管理</span>
        </el-menu-item>
        <el-menu-item index="/alerts">
          <el-icon><Warning /></el-icon>
          <span>告警中心</span>
        </el-menu-item>
        <el-menu-item v-if="!isAdmin" index="/analytics">
          <el-icon><TrendCharts /></el-icon>
          <span>数据分析</span>
        </el-menu-item>
        <el-menu-item index="/traceability">
          <el-icon><Tickets /></el-icon>
          <span>批次溯源</span>
        </el-menu-item>
        <el-menu-item v-if="!isAdmin" index="/farmer-feedback">
          <el-icon><ChatDotRound /></el-icon>
          <span>问题反馈</span>
        </el-menu-item>
        <el-menu-item index="/profile">
          <el-icon><User /></el-icon>
          <span>个人中心</span>
        </el-menu-item>
        <template v-if="isAdmin">
          <el-menu-item index="/users">
            <el-icon><UserFilled /></el-icon>
            <span>农户管理</span>
          </el-menu-item>
          <el-menu-item index="/feedback">
            <el-icon><ChatDotRound /></el-icon>
            <span>反馈处理</span>
          </el-menu-item>
        </template>
      </el-menu>
    </el-aside>

    <el-container class="console__body">
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
import { ChatDotRound, DataAnalysis, House, Operation, Tickets, TrendCharts, User, UserFilled, Warning } from '@element-plus/icons-vue'
import { useSessionStore } from '../stores/session'

const router = useRouter()
const session = useSessionStore()
const isAdmin = computed(() => session.profile?.role === 'ADMIN')
const currentDate = computed(() => new Date().toLocaleString('zh-CN'))
const operatorName = computed(() => session.profile?.username || '用户')

const logout = () => {
  session.signOut()
  router.push('/login')
}
</script>

<style scoped>
.console { min-height: 100vh; }
.console__aside {
  position: fixed;
  inset: 0 auto 0 0;
  z-index: 10;
  border-right: 1px solid var(--line);
  background: linear-gradient(180deg, #ffffff, #eff8eb);
  box-shadow: 16px 0 48px rgba(42, 91, 48, 0.1);
}
.console__body { min-height: 100vh; margin-left: 248px; }
.brand { display: flex; gap: 12px; align-items: center; padding: 24px 20px; }
.brand__mark {
  display: grid;
  width: 44px;
  height: 44px;
  place-items: center;
  border-radius: 8px;
  background: linear-gradient(135deg, var(--brand), var(--brand-strong));
  color: #fff;
  font-weight: 900;
}
.brand strong, .brand span { display: block; }
.brand strong { color: var(--ink); font-size: 18px; }
.brand span { margin-top: 4px; color: var(--muted); font-size: 12px; }
.nav { border: 0; background: transparent; }
.nav :deep(.el-menu-item) {
  height: 48px;
  margin: 4px 12px;
  border-radius: var(--radius);
  color: #45604b;
  font-weight: 800;
}
.nav :deep(.el-menu-item.is-active), .nav :deep(.el-menu-item:hover) {
  background: rgba(83, 184, 106, 0.12);
  color: var(--brand-strong);
  box-shadow: inset 3px 0 0 var(--brand);
}
.console__header {
  display: flex;
  height: 84px;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--line);
  background: rgba(255, 255, 255, 0.78);
  backdrop-filter: blur(16px);
}
.console__header p, .console__header h1 { margin: 0; }
.console__header p { color: var(--muted); font-size: 13px; }
.console__header h1 { margin-top: 4px; color: var(--ink); font-size: 22px; }
.header-actions { display: flex; gap: 14px; align-items: center; }
.operator {
  display: inline-flex;
  align-items: center;
  cursor: pointer;
  border: 1px solid var(--line);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.84);
  color: var(--ink);
  padding: 9px 14px;
  font-weight: 800;
}
.console__main { min-height: calc(100vh - 84px); padding: 24px; }
</style>
