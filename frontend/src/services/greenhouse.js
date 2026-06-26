import { http } from './http'

export const fetchOverview = (greenhouseId) => http.get('/greenhouses/overview', { params: { greenhouseId } })
export const fetchGreenhouses = () => http.get('/greenhouses')
export const createGreenhouse = (payload) => http.post('/greenhouses', payload)
export const fetchDevices = (greenhouseId) => http.get('/greenhouses/devices', { params: { greenhouseId } })
export const createDevice = (payload) => http.post('/greenhouses/devices', payload)
export const fetchAlerts = (greenhouseId) => http.get('/greenhouses/alerts', { params: { greenhouseId } })
export const fetchAlertDetails = (greenhouseId) => http.get('/greenhouses/alerts/detail', { params: { greenhouseId } })
export const fetchTraceability = (greenhouseId) => http.get('/greenhouses/traceability', { params: { greenhouseId } })
export const sendDeviceCommand = (payload) => http.post('/greenhouses/devices/commands', payload)
