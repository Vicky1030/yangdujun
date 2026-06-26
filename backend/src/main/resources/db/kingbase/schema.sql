CREATE TABLE IF NOT EXISTS app_user (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  password_hash VARCHAR(128) NOT NULL,
  role_code VARCHAR(32) NOT NULL,
  phone VARCHAR(32) UNIQUE,
  email VARCHAR(128) UNIQUE,
  display_name VARCHAR(64),
  avatar_url VARCHAR(512),
  gender VARCHAR(16),
  bio VARCHAR(500),
  last_login_ip VARCHAR(64),
  enabled BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS greenhouse (
  id BIGSERIAL PRIMARY KEY,
  owner_user_id BIGINT REFERENCES app_user(id),
  name VARCHAR(128) NOT NULL,
  location VARCHAR(255),
  status VARCHAR(32) NOT NULL,
  area NUMERIC(10,2) NOT NULL DEFAULT 0,
  crop_stage VARCHAR(64),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS greenhouse_device (
  id BIGSERIAL PRIMARY KEY,
  greenhouse_id BIGINT NOT NULL REFERENCES greenhouse(id),
  name VARCHAR(128) NOT NULL,
  category VARCHAR(64) NOT NULL,
  status VARCHAR(32) NOT NULL,
  location VARCHAR(255),
  auto_mode BOOLEAN NOT NULL DEFAULT FALSE,
  health_score INT NOT NULL DEFAULT 100,
  last_command VARCHAR(64),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS telemetry_snapshot (
  id BIGSERIAL PRIMARY KEY,
  greenhouse_id BIGINT NOT NULL REFERENCES greenhouse(id),
  temperature NUMERIC(6,2) NOT NULL,
  humidity NUMERIC(6,2) NOT NULL,
  light_lux INT NOT NULL,
  co2_ppm INT NOT NULL,
  soil_moisture NUMERIC(6,2) NOT NULL,
  collected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS greenhouse_alert (
  id BIGSERIAL PRIMARY KEY,
  greenhouse_id BIGINT NOT NULL REFERENCES greenhouse(id),
  device_id BIGINT REFERENCES greenhouse_device(id),
  title VARCHAR(160) NOT NULL,
  description VARCHAR(500),
  level VARCHAR(32) NOT NULL,
  status VARCHAR(32) NOT NULL,
  occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP
);

ALTER TABLE greenhouse_alert ADD COLUMN IF NOT EXISTS device_id BIGINT REFERENCES greenhouse_device(id);

CREATE TABLE IF NOT EXISTS traceability_record (
  id BIGSERIAL PRIMARY KEY,
  greenhouse_id BIGINT NOT NULL REFERENCES greenhouse(id),
  batch_no VARCHAR(64) NOT NULL,
  operation VARCHAR(128) NOT NULL,
  operator VARCHAR(64) NOT NULL,
  operation_date DATE NOT NULL,
  note VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS verification_code (
  id BIGSERIAL PRIMARY KEY,
  receiver VARCHAR(128) NOT NULL,
  scene VARCHAR(32) NOT NULL,
  code VARCHAR(12) NOT NULL,
  used BOOLEAN NOT NULL DEFAULT FALSE,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS feedback (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES app_user(id),
  category VARCHAR(64) NOT NULL,
  content VARCHAR(1000) NOT NULL,
  contact VARCHAR(128),
  status VARCHAR(32) NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS operation_log (
  id BIGSERIAL PRIMARY KEY,
  trace_id VARCHAR(64),
  username VARCHAR(64),
  client_ip VARCHAR(64),
  module_name VARCHAR(64),
  action_name VARCHAR(128),
  request_uri VARCHAR(255),
  http_method VARCHAR(16),
  success BOOLEAN NOT NULL,
  elapsed_ms BIGINT,
  message VARCHAR(500),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_telemetry_greenhouse_time ON telemetry_snapshot(greenhouse_id, collected_at DESC);
CREATE INDEX IF NOT EXISTS idx_alert_status_level ON greenhouse_alert(status, level);
CREATE INDEX IF NOT EXISTS idx_operation_log_created_at ON operation_log(created_at DESC);

CREATE OR REPLACE VIEW v_greenhouse_realtime AS
SELECT g.id, g.name, g.status, t.temperature, t.humidity, t.light_lux, t.co2_ppm, t.soil_moisture, t.collected_at
FROM greenhouse g
LEFT JOIN telemetry_snapshot t ON t.id = (
  SELECT ts.id FROM telemetry_snapshot ts
  WHERE ts.greenhouse_id = g.id
  ORDER BY ts.collected_at DESC
  LIMIT 1
);
