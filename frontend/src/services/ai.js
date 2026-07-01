import { aiHttp, http } from './http'

export const chatWithAi = (payload) => aiHttp.post('/ai/chat', payload)
export const diagnoseImage = (payload) => aiHttp.post('/ai/diagnosis', payload)
export const rebuildAiKnowledge = () => aiHttp.post('/ai/knowledge/rebuild')
export const fetchAiSuggestions = () => http.get('/ai/suggestions')
export const downlinkAiSuggestion = (id, payload) => http.post(`/ai/suggestions/${id}/downlink`, payload)
