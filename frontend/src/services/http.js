import axios from 'axios'
import { ElMessage } from 'element-plus'

export const http = axios.create({
  baseURL: '/api/v1',
  timeout: 10000
})

http.interceptors.response.use((response) => {
  const result = response.data
  if (result && result.code === 0) {
    return result.data
  }
  const message = result?.message || '请求失败'
  ElMessage.error(message)
  return Promise.reject(new Error(message))
}, (error) => {
  const message = error.response?.data?.message || error.message || '网络异常，请稍后重试'
  ElMessage.error(message)
  return Promise.reject(new Error(message))
})
