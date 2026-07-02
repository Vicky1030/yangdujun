import express from 'express'
import cors from 'cors'
import { query } from './db.js'
import { buildTwinOverview } from './twinMapper.js'

const app = express()
const port = Number(process.env.BACKEND_PORT || 8080)

app.use(cors())
app.use(express.json())

app.get('/api/health', async (_request, response) => {
  try {
    const rows = await query('SELECT 1 AS ok')
    response.json({ ok: true, database: rows[0]?.ok === 1 })
  } catch (error) {
    response.status(500).json({ ok: false, message: error.message })
  }
})

app.get('/api/twin/overview', async (_request, response) => {
  try {
    const [greenhouses, devices, telemetry, alerts] = await Promise.all([
      query(`
        SELECT id, owner_user_id, name, location, status, area, crop_stage, created_at, updated_at
        FROM public.greenhouse
        ORDER BY id
      `),
      query(`
        SELECT id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, created_at, updated_at
        FROM public.greenhouse_device
        ORDER BY greenhouse_id, id
      `),
      query(`
        SELECT id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at
        FROM (
          SELECT
            id, greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture, collected_at,
            ROW_NUMBER() OVER (PARTITION BY greenhouse_id ORDER BY collected_at DESC) AS row_num
          FROM public.telemetry_snapshot
        ) latest
        WHERE row_num = 1
        ORDER BY greenhouse_id
      `),
      query(`
        SELECT id, greenhouse_id, title, description, level, status, occurred_at, resolved_at, device_id
        FROM public.greenhouse_alert
        ORDER BY occurred_at DESC
        LIMIT 20
      `),
    ])

    response.json(buildTwinOverview({ greenhouses, devices, telemetry, alerts }))
  } catch (error) {
    response.status(500).json({
      message: '读取数字孪生数据失败',
      detail: error.message,
    })
  }
})

app.patch('/api/twin/devices/:id/command', async (request, response) => {
  const { id } = request.params
  const { runningStatus } = request.body
  const nextStatus = runningStatus === 'ON' ? 'ON' : 'OFF'

  try {
    const rows = await query(
      `
        UPDATE public.greenhouse_device
        SET status = $1, last_command = $1, updated_at = CURRENT_TIMESTAMP
        WHERE id = $2
        RETURNING id, greenhouse_id, name, category, status, location, auto_mode, health_score, last_command, updated_at
      `,
      [nextStatus, id],
    )

    if (!rows.length) {
      response.status(404).json({ message: '设备不存在' })
      return
    }

    response.json({ ok: true, device: rows[0] })
  } catch (error) {
    response.status(500).json({
      message: '设备控制失败',
      detail: error.message,
    })
  }
})

app.listen(port, () => {
  console.log(`Digital twin backend is running at http://localhost:${port}`)
})
