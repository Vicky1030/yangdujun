INSERT INTO app_user(username, password_hash, role_code, phone, email, display_name, gender, bio)
SELECT 'farmer001', '{bcrypt}$2a$10$JkchLJY4LoYghNpK4kJ5Ae2TQwAotSKfih8CV0McdCrw.7HfMS1MC', 'FARMER', '13900000001', 'farmer001@example.com', '示范农户', 'MALE', '负责 A01 大棚日常巡检和出菇期管理'
WHERE NOT EXISTS (SELECT 1 FROM app_user WHERE username='farmer001');

INSERT INTO greenhouse(owner_user_id, name, location, status, area, crop_stage)
SELECT u.id, 'A01 羊肚菌智能大棚', '温室一区 / 北侧', 'ONLINE', 420.00, '出菇期'
FROM app_user u WHERE u.username='farmer001'
AND NOT EXISTS (SELECT 1 FROM greenhouse WHERE name='A01 羊肚菌智能大棚');

INSERT INTO greenhouse_device(greenhouse_id, name, category, status, location, auto_mode, health_score)
SELECT g.id, '循环风机组', '通风', 'RUNNING', '东侧风道', TRUE, 96 FROM greenhouse g WHERE g.name='A01 羊肚菌智能大棚'
AND NOT EXISTS (SELECT 1 FROM greenhouse_device WHERE name='循环风机组');

INSERT INTO telemetry_snapshot(greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture)
SELECT g.id, 21.8, 84.6, 4280, 790, 62.5 FROM greenhouse g WHERE g.name='A01 羊肚菌智能大棚';

INSERT INTO greenhouse_alert(greenhouse_id, device_id, title, description, level, status)
SELECT g.id, d.id, '湿度波动偏高', '连续 8 分钟超过目标上限 3.5%，请检查加湿策略和通风设备。', 'WARNING', 'OPEN'
FROM greenhouse g
LEFT JOIN greenhouse_device d ON d.greenhouse_id = g.id AND d.name='循环风机组'
WHERE g.name='A01 羊肚菌智能大棚'
AND NOT EXISTS (SELECT 1 FROM greenhouse_alert WHERE title='湿度波动偏高');

INSERT INTO traceability_record(greenhouse_id, batch_no, operation, operator, operation_date, note)
SELECT g.id, 'ML-202606-A01', '基质入棚', '张工', CURRENT_DATE - 28, '完成批次建档并绑定溯源码' FROM greenhouse g WHERE g.name='A01 羊肚菌智能大棚'
AND NOT EXISTS (SELECT 1 FROM traceability_record WHERE batch_no='ML-202606-A01' AND operation='基质入棚');