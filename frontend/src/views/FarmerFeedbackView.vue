<template>
  <section class="panel feedback-page" v-loading="loading">
    <aside class="conversation-list">
      <div class="chat-title">
        <h2 class="section-title">问题反馈</h2>
        <p class="muted">{{ isAdmin ? '选择农户会话，回复处理意见。' : '选择管理员，像聊天一样提交问题。' }}</p>
      </div>

      <button
        v-for="item in conversations"
        :key="itemKey(item)"
        class="conversation-item"
        :class="{ active: itemKey(item) === itemKey(selected || {}) }"
        @click="selectConversation(item)"
      >
        <el-avatar class="avatar" :size="54" :src="avatarUrl(item)">{{ avatarName(item) }}</el-avatar>
        <div class="conversation-copy">
          <strong>{{ displayName(item) }}</strong>
          <span>{{ item.last_message || '暂无聊天记录' }}</span>
        </div>
      </button>
      <el-empty v-if="!conversations.length" description="暂无会话" />
    </aside>

    <main class="chat-panel">
      <template v-if="selected">
        <header class="chat-panel__head">
          <el-avatar :size="50" :src="avatarUrl(selected)">{{ avatarName(selected) }}</el-avatar>
          <div>
            <strong>{{ displayName(selected) }}</strong>
            <p>{{ isAdmin ? '农户反馈会话实时保存' : '管理员会话实时保存' }}</p>
          </div>
        </header>

        <div class="messages">
          <div
            v-for="message in messages"
            :key="message.id"
            class="message"
            :class="{ mine: Number(message.sender_user_id) === Number(session.profile.id) }"
          >
            <el-avatar class="message-avatar" :size="38" :src="messageAvatar(message)">{{ messageAvatarName(message) }}</el-avatar>
            <div class="bubble">
              <img v-if="message.message_type === 'IMAGE' && message.image_url" :src="message.image_url" alt="反馈图片" />
              <p>{{ message.content }}</p>
            </div>
          </div>
          <el-empty v-if="!messages.length" description="还没有消息" />
        </div>

        <footer class="composer">
          <el-input v-model="draft" type="textarea" :rows="2" placeholder="输入反馈内容或处理意见" />
          <el-input v-model.trim="imageUrl" placeholder="图片地址，可选" />
          <el-button type="primary" :loading="sending" @click="sendMessage">发送</el-button>
        </footer>
      </template>
      <el-empty v-else description="请选择一个会话" />
    </main>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchFeedbackConversations, fetchFeedbackMessages, sendFeedbackMessage } from '../services/user'
import { useSessionStore } from '../stores/session'

const session = useSessionStore()
const isAdmin = computed(() => session.profile?.role === 'ADMIN')
const loading = ref(false)
const sending = ref(false)
const conversations = ref([])
const selected = ref(null)
const messages = ref([])
const draft = ref('')
const imageUrl = ref('')

const itemKey = item => isAdmin.value ? item.conversation_id || item.id : item.conversation_id || `admin-${item.admin_user_id}`
const displayName = item => isAdmin.value
  ? `${item.farmer_name || item.farmer_username || '农户'}`
  : `${item.display_name || item.username || '管理员'}`
const avatarName = item => displayName(item).slice(0, 1)

const defaultAvatar = (role, gender) => {
  const female = String(gender || '').toUpperCase() === 'FEMALE'
  if (String(role || '').toUpperCase() === 'ADMIN') {
    return female ? '/avatars/female_admin.png' : '/avatars/male_admin.png'
  }
  return female ? '/avatars/female_farmer.png' : '/avatars/male_farmer.jpg'
}

const avatarUrl = item => {
  if (isAdmin.value) {
    return item.farmer_avatar_url || defaultAvatar('FARMER', item.farmer_gender)
  }
  return item.avatar_url || item.admin_avatar_url || defaultAvatar('ADMIN', item.gender || item.admin_gender)
}

const messageRole = message => {
  if (Number(message.sender_user_id) === Number(session.profile.id)) return session.profile.role
  return isAdmin.value ? 'FARMER' : 'ADMIN'
}
const messageAvatar = message => message.avatar_url || defaultAvatar(messageRole(message), message.gender)
const messageAvatarName = message => `${message.display_name || message.username || '用'}`.slice(0, 1)

const loadConversations = async () => {
  loading.value = true
  try {
    conversations.value = await fetchFeedbackConversations()
    if (!selected.value && conversations.value.length) {
      await selectConversation(conversations.value[0])
    }
  } finally {
    loading.value = false
  }
}

const selectConversation = async item => {
  selected.value = item
  messages.value = []
  const id = item.conversation_id || item.id
  if (id) {
    messages.value = await fetchFeedbackMessages(id)
  }
}

const sendMessage = async () => {
  if (!selected.value) return
  if (!draft.value.trim() && !imageUrl.value) return ElMessage.warning('请输入消息内容')
  sending.value = true
  try {
    const payload = isAdmin.value
      ? {
          conversationId: selected.value.conversation_id || selected.value.id,
          content: draft.value.trim() || '图片反馈',
          messageType: imageUrl.value ? 'IMAGE' : 'TEXT',
          imageUrl: imageUrl.value || null
        }
      : {
          adminUserId: selected.value.admin_user_id,
          content: draft.value.trim() || '图片反馈',
          messageType: imageUrl.value ? 'IMAGE' : 'TEXT',
          imageUrl: imageUrl.value || null
        }
    await sendFeedbackMessage(payload)
    draft.value = ''
    imageUrl.value = ''
    await loadConversations()
    const next = conversations.value.find(item => itemKey(item) === itemKey(selected.value))
    if (next) await selectConversation(next)
  } finally {
    sending.value = false
  }
}

onMounted(loadConversations)
</script>

<style scoped>
.feedback-page { display: grid; grid-template-columns: 340px minmax(0, 1fr); min-height: 650px; padding: 0; overflow: hidden; }
.conversation-list { border-right: 1px solid var(--line); padding: 24px; background: rgba(255,255,255,.58); }
.chat-title { margin-bottom: 18px; }
.conversation-item {
  width: 100%;
  display: flex;
  gap: 14px;
  align-items: center;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255,255,255,.82);
  padding: 14px;
  margin-bottom: 12px;
  text-align: left;
  cursor: pointer;
  transition: transform .18s ease, border-color .18s ease, box-shadow .18s ease;
}
.conversation-item:hover { transform: translateY(-1px); border-color: rgba(72, 158, 92, .45); }
.conversation-item.active { border-color: var(--brand); box-shadow: 0 14px 30px rgba(72, 158, 92, .15); }
.avatar { flex: 0 0 auto; border: 2px solid rgba(255,255,255,.92); box-shadow: 0 10px 22px rgba(39, 80, 47, .14); }
.conversation-copy { min-width: 0; }
.conversation-copy strong, .conversation-copy span { display: block; }
.conversation-copy strong { color: var(--ink); }
.conversation-copy span { margin-top: 5px; color: var(--muted); font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.chat-panel { display: flex; min-width: 0; flex-direction: column; }
.chat-panel__head { display: flex; align-items: center; gap: 14px; padding: 24px; border-bottom: 1px solid var(--line); background: rgba(255,255,255,.4); }
.chat-panel__head strong { font-size: 22px; }
.chat-panel__head p { margin: 6px 0 0; color: var(--muted); }
.messages { flex: 1; overflow: auto; padding: 24px; }
.message { display: flex; align-items: flex-start; margin-bottom: 14px; }
.message.mine { justify-content: flex-end; }
.message-avatar { flex: 0 0 auto; margin-right: 10px; border: 2px solid rgba(255,255,255,.9); box-shadow: 0 8px 18px rgba(39, 80, 47, .13); }
.message.mine .message-avatar { order: 2; margin-right: 0; margin-left: 10px; }
.bubble {
  max-width: min(520px, 74%);
  border: 1px solid var(--line);
  border-radius: 8px;
  background: #fff;
  padding: 12px 14px;
  box-shadow: 0 10px 24px rgba(35, 78, 45, .08);
}
.message.mine .bubble { background: #dff7de; border-color: rgba(78, 178, 88, .35); }
.bubble img { display: block; max-width: 260px; max-height: 180px; border-radius: 6px; margin-bottom: 8px; object-fit: cover; }
.bubble p { margin: 0; white-space: pre-wrap; }
.composer { display: grid; grid-template-columns: minmax(0, 1fr) 260px auto; gap: 12px; padding: 18px 24px; border-top: 1px solid var(--line); background: rgba(255,255,255,.58); }

@media (max-width: 900px) {
  .feedback-page { grid-template-columns: 1fr; }
  .conversation-list { border-right: 0; border-bottom: 1px solid var(--line); }
  .composer { grid-template-columns: 1fr; }
}
</style>
