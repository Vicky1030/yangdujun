import { createRouter, createWebHistory } from 'vue-router'
import { useSessionStore } from '../stores/session'
import LoginView from '../views/LoginView.vue'
import ConsoleLayout from '../layouts/ConsoleLayout.vue'
import DashboardView from '../views/DashboardView.vue'
import DeviceView from '../views/DeviceView.vue'
import AlertView from '../views/AlertView.vue'
import TraceabilityView from '../views/TraceabilityView.vue'
import ProfileView from '../views/ProfileView.vue'
import UserAdminView from '../views/UserAdminView.vue'
import FeedbackAdminView from '../views/FeedbackAdminView.vue'
import OperationLogView from '../views/OperationLogView.vue'
import FarmerHomeView from '../views/FarmerHomeView.vue'

const routes = [
  { path: '/login', component: LoginView },
  {
    path: '/',
    component: ConsoleLayout,
    children: [
      { path: '', name: 'dashboard', component: DashboardView, meta: { title: '管理总览' } },
      { path: 'devices', name: 'devices', component: DeviceView, meta: { title: '设备管理' } },
      { path: 'alerts', name: 'alerts', component: AlertView, meta: { title: '告警中心' } },
      { path: 'traceability', name: 'traceability', component: TraceabilityView, meta: { title: '批次溯源' } },
      { path: 'profile', name: 'profile', component: ProfileView, meta: { title: '个人中心' } },
      { path: 'users', name: 'users', component: UserAdminView, meta: { title: '农户管理', role: 'ADMIN' } },
      { path: 'feedback', name: 'feedback', component: FeedbackAdminView, meta: { title: '反馈处理', role: 'ADMIN' } },
      { path: 'logs', name: 'logs', component: OperationLogView, meta: { title: '操作审计', role: 'ADMIN' } },
      { path: 'farmer', name: 'farmer', component: FarmerHomeView, meta: { title: '农户工作台' } }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to) => {
  const session = useSessionStore()
  if (to.path !== '/login' && !session.token) {
    return '/login'
  }
  if (to.meta.role && session.profile?.role !== to.meta.role) {
    return '/'
  }
  if (to.path === '/login' && session.token) {
    return '/'
  }
  return true
})

export default router
