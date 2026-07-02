import 'dotenv/config'
import pg from 'pg'

const { Pool } = pg

export const pool = new Pool({
  host: process.env.KINGBASE_HOST || '101.42.99.139',
  port: Number(process.env.KINGBASE_PORT || 54321),
  database: process.env.KINGBASE_DATABASE || 'smart_greenhouse',
  user: process.env.KINGBASE_USER || 'system',
  password: process.env.KINGBASE_PASSWORD || '123456',
  max: 8,
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 5_000,
})

export async function query(sql, params = []) {
  const result = await pool.query(sql, params)
  return result.rows
}
