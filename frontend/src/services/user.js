import { http } from './http'

export const fetchProfile = (id) => http.get(`/users/${id}/profile`)
export const updateProfile = (id, payload) => http.put(`/users/${id}/profile`, payload)
export const submitFeedback = (payload) => http.post('/users/feedback', payload)
export const fetchUsers = () => http.get('/users')
export const fetchFeedbacks = () => http.get('/users/feedback')
export const fetchOperationLogs = () => http.get('/users/operation-logs')
