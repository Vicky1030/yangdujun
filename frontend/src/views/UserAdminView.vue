<template>
  <section class="panel" v-loading="loading">
    <div class="panel-head">
      <div>
        <h2 class="section-title">农户与管理员管理</h2>
        <p class="muted">双击表格中的用户名、手机号、邮箱、昵称或简介可直接编辑；状态列可直接启用或停用账号。</p>
      </div>
      <div class="head-actions">
        <el-button @click="openCreate('FARMER')">新增农户</el-button>
        <el-button type="primary" @click="openCreate('ADMIN')">新增管理员</el-button>
      </div>
    </div>

    <el-table :data="users" style="width: 100%; margin-top: 16px" row-key="id">
      <el-table-column label="头像" width="82">
        <template #default="{ row }">
          <el-avatar :size="42" :src="row.avatar_url || defaultAvatar(row.role_code, row.gender)">{{ avatarText(row) }}</el-avatar>
        </template>
      </el-table-column>
      <el-table-column prop="username" label="用户名" min-width="140">
        <template #default="{ row }"><EditableCell :row="row" field="username" @save="inlineSave" /></template>
      </el-table-column>
      <el-table-column prop="display_name" label="昵称" min-width="130">
        <template #default="{ row }"><EditableCell :row="row" field="display_name" @save="inlineSave" /></template>
      </el-table-column>
      <el-table-column prop="role_code" label="角色" width="110">
        <template #default="{ row }">{{ row.role_code === 'ADMIN' ? '管理员' : '农户' }}</template>
      </el-table-column>
      <el-table-column prop="phone" label="手机号" min-width="140">
        <template #default="{ row }"><EditableCell :row="row" field="phone" @save="inlineSave" /></template>
      </el-table-column>
      <el-table-column prop="email" label="邮箱" min-width="180">
        <template #default="{ row }"><EditableCell :row="row" field="email" @save="inlineSave" /></template>
      </el-table-column>
      <el-table-column prop="greenhouse_count" label="绑定大棚" width="110" />
      <el-table-column prop="enabled" label="状态" width="120">
        <template #default="{ row }">
          <el-button :type="row.enabled ? 'success' : 'info'" size="small" plain @click="toggleEnabled(row)">
            {{ row.enabled ? '启用中' : '已停用' }}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="240">
        <template #default="{ row }">
          <el-button link type="primary" @click="openEdit(row)">完整编辑</el-button>
          <el-button v-if="row.role_code === 'FARMER'" link type="success" @click="openBind(row)">绑定大棚</el-button>
          <el-button link type="danger" @click="removeUser(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="userDialog" :title="editingId ? '编辑用户' : '新增用户'" width="560px">
      <el-form label-position="top">
        <el-form-item label="角色">
          <el-select v-model="userForm.roleCode" style="width: 100%">
            <el-option label="农户" value="FARMER" />
            <el-option label="管理员" value="ADMIN" />
          </el-select>
        </el-form-item>
        <el-form-item label="用户名"><el-input v-model.trim="userForm.username" /></el-form-item>
        <el-form-item label="密码"><el-input v-model="userForm.password" type="password" show-password placeholder="留空则不修改，新增默认 123456" /></el-form-item>
        <el-form-item label="昵称"><el-input v-model.trim="userForm.displayName" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model.trim="userForm.phone" /></el-form-item>
        <el-form-item label="邮箱"><el-input v-model.trim="userForm.email" /></el-form-item>
        <el-form-item label="性别">
          <el-select v-model="userForm.gender" style="width: 100%">
            <el-option label="未知" value="UNKNOWN" />
            <el-option label="男" value="MALE" />
            <el-option label="女" value="FEMALE" />
          </el-select>
        </el-form-item>
        <el-form-item label="简介"><el-input v-model.trim="userForm.bio" type="textarea" :rows="3" /></el-form-item>
        <el-form-item label="启用"><el-switch v-model="userForm.enabled" /></el-form-item>
        <div class="dialog-actions">
          <el-button @click="userDialog = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="submitUser">保存</el-button>
        </div>
      </el-form>
    </el-dialog>

    <el-dialog v-model="bindDialog" title="为农户分配大棚" width="560px">
      <p class="muted">一个农户可以绑定多个大棚，一个大棚只能被一个农户控制。</p>
      <el-select v-model="bindingIds" multiple filterable style="width: 100%; margin-top: 12px" placeholder="选择大棚">
        <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
      <div class="dialog-actions">
        <el-button @click="bindDialog = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="submitBind">保存绑定</el-button>
      </div>
    </el-dialog>
  </section>
</template>

<script setup>
import { defineComponent, h, onMounted, reactive, ref } from 'vue'
import { ElInput, ElMessage, ElMessageBox } from 'element-plus'
import { fetchGreenhouses } from '../services/greenhouse'
import { bindFarmerGreenhouses, createUser, deleteUser, fetchFarmerGreenhouses, fetchUsers, updateUser } from '../services/user'

const EditableCell = defineComponent({
  props: { row: Object, field: String },
  emits: ['save'],
  setup(props, { emit }) {
    const editing = ref(false)
    const value = ref('')
    const start = () => { value.value = props.row[props.field] || ''; editing.value = true }
    const finish = () => { editing.value = false; emit('save', props.row, props.field, value.value) }
    return () => editing.value
      ? h(ElInput, { modelValue: value.value, 'onUpdate:modelValue': v => value.value = v, onBlur: finish, onKeyup: e => e.key === 'Enter' && finish(), autofocus: true })
      : h('span', { class: 'editable-cell', onDblclick: start }, props.row[props.field] || '-')
  }
})

const loading = ref(false)
const saving = ref(false)
const users = ref([])
const greenhouses = ref([])
const userDialog = ref(false)
const bindDialog = ref(false)
const editingId = ref(null)
const bindingUser = ref(null)
const bindingIds = ref([])
const userForm = reactive({ username: '', password: '', roleCode: 'FARMER', phone: '', email: '', displayName: '', gender: 'UNKNOWN', bio: '', enabled: true })

const defaultAvatar = (role, gender) => {
  const female = String(gender || '').toUpperCase() === 'FEMALE'
  if (String(role || '').toUpperCase() === 'ADMIN') {
    return female ? '/avatars/female_admin.png' : '/avatars/male_admin.png'
  }
  return female ? '/avatars/female_farmer.png' : '/avatars/male_farmer.jpg'
}

const avatarText = row => `${row.display_name || row.username || '用'}`.slice(0, 1)

const rowToPayload = row => ({
  username: row.username,
  password: '',
  roleCode: row.role_code,
  phone: row.phone || '',
  email: row.email || '',
  displayName: row.display_name || '',
  gender: row.gender || 'UNKNOWN',
  bio: row.bio || '',
  enabled: Boolean(row.enabled)
})

const load = async () => {
  loading.value = true
  try {
    const [userRows, greenhouseRows] = await Promise.all([fetchUsers(), fetchGreenhouses()])
    users.value = userRows
    greenhouses.value = greenhouseRows
  } finally { loading.value = false }
}

const resetForm = role => Object.assign(userForm, { username: role === 'ADMIN' ? 'admin' : '', password: '', roleCode: role, phone: '', email: '', displayName: '', gender: 'UNKNOWN', bio: '', enabled: true })
const openCreate = role => { editingId.value = null; resetForm(role); userDialog.value = true }
const openEdit = row => { editingId.value = row.id; Object.assign(userForm, rowToPayload(row)); userDialog.value = true }

const submitUser = async () => {
  if (!userForm.username) return ElMessage.warning('请填写用户名')
  saving.value = true
  try {
    if (editingId.value) await updateUser(editingId.value, userForm)
    else await createUser(userForm)
    ElMessage.success('用户已保存')
    userDialog.value = false
    await load()
  } finally { saving.value = false }
}

const inlineSave = async (row, field, value) => {
  const keyMap = { display_name: 'displayName', role_code: 'roleCode' }
  const payload = rowToPayload(row)
  payload[keyMap[field] || field] = value
  await updateUser(row.id, payload)
  ElMessage.success('已更新')
  await load()
}

const toggleEnabled = async row => {
  const payload = rowToPayload(row)
  payload.enabled = !row.enabled
  await updateUser(row.id, payload)
  ElMessage.success(payload.enabled ? '账号已启用' : '账号已停用')
  await load()
}

const removeUser = async row => {
  await ElMessageBox.confirm(`确认删除用户“${row.username}”？`, '删除用户', {
    type: 'warning',
    confirmButtonText: '确定',
    cancelButtonText: '取消'
  })
  await deleteUser(row.id)
  ElMessage.success('用户已删除')
  await load()
}

const openBind = async row => {
  bindingUser.value = row
  const bound = await fetchFarmerGreenhouses(row.id)
  bindingIds.value = bound.map(item => item.id)
  bindDialog.value = true
}

const submitBind = async () => {
  saving.value = true
  try {
    await bindFarmerGreenhouses(bindingUser.value.id, { greenhouseIds: bindingIds.value })
    ElMessage.success('大棚绑定已保存')
    bindDialog.value = false
    await load()
  } finally { saving.value = false }
}

onMounted(load)
</script>

<style scoped>
.panel-head, .head-actions, .dialog-actions { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
.dialog-actions { justify-content: flex-end; margin-top: 18px; }
.editable-cell { display: inline-block; min-height: 24px; min-width: 42px; cursor: text; }
.editable-cell:hover { color: var(--brand-strong); text-decoration: underline; }
</style>
