package com.morel.greenhouse.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;

@Component
@Profile("kingbase")
public class DatabaseInitializer implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(DatabaseInitializer.class);

    private final DataSource dataSource;
    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final String adminPassword;

    public DatabaseInitializer(
            DataSource dataSource,
            JdbcTemplate jdbcTemplate,
            PasswordEncoder passwordEncoder,
            @Value("${greenhouse.security.admin-default-password}") String adminPassword
    ) {
        this.dataSource = dataSource;
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
        this.adminPassword = adminPassword;
    }

    @Override
    public void run(ApplicationArguments args) {
        log.info("Initializing Kingbase schema and seed data");
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.setSqlScriptEncoding("UTF-8");
        populator.addScript(new ClassPathResource("db/kingbase/schema.sql"));
        populator.addScript(new ClassPathResource("db/kingbase/seed.sql"));
        populator.execute(dataSource);
        cleanupCorruptedSeedData();
        normalizeLegacyDeviceStatus();
        normalizeDemoSeedText();

        Integer exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM app_user WHERE username = ?",
                Integer.class,
                "admin"
        );
        if (exists != null && exists == 0) {
            jdbcTemplate.update("""
                    INSERT INTO app_user(username, password_hash, role_code, phone, email, display_name, gender, bio)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    "admin",
                    "{bcrypt}" + passwordEncoder.encode(adminPassword),
                    "ADMIN",
                    "13800000000",
                    "admin@example.com",
                    "System Admin",
                    "UNKNOWN",
                    "Platform super administrator"
            );
            log.info("Admin account initialized: username=admin");
        }
    }

    private void cleanupCorruptedSeedData() {
        String corruptedGreenhouseCondition = "name LIKE '%鑿%' OR name LIKE '%ç%' OR location LIKE '%娓%' OR crop_stage LIKE '%鍑%'";
        jdbcTemplate.update("DELETE FROM greenhouse_alert WHERE title LIKE '%娉%' OR description LIKE '%杩%'");
        jdbcTemplate.update("DELETE FROM greenhouse_device WHERE name LIKE '%椋%' OR category LIKE '%閫%' OR location LIKE '%涓%'");
        jdbcTemplate.update("DELETE FROM telemetry_snapshot WHERE greenhouse_id IN (SELECT id FROM greenhouse WHERE " + corruptedGreenhouseCondition + ")");
        jdbcTemplate.update("DELETE FROM traceability_record WHERE greenhouse_id IN (SELECT id FROM greenhouse WHERE " + corruptedGreenhouseCondition + ")");
        jdbcTemplate.update("DELETE FROM greenhouse_alert WHERE greenhouse_id IN (SELECT id FROM greenhouse WHERE " + corruptedGreenhouseCondition + ")");
        jdbcTemplate.update("DELETE FROM greenhouse_device WHERE greenhouse_id IN (SELECT id FROM greenhouse WHERE " + corruptedGreenhouseCondition + ")");
        int removed = jdbcTemplate.update("DELETE FROM greenhouse WHERE " + corruptedGreenhouseCondition);
        if (removed > 0) {
            log.warn("Removed corrupted seed greenhouse rows: count={}", removed);
        }
    }

    private void normalizeLegacyDeviceStatus() {
        int updated = jdbcTemplate.update("""
                UPDATE greenhouse_device
                SET status = CASE status
                    WHEN 'ON' THEN 'RUNNING'
                    WHEN 'OFF' THEN 'STOPPED'
                    ELSE status
                END
                WHERE status IN ('ON', 'OFF')
                """);
        if (updated > 0) {
            log.info("Normalized legacy device status rows: count={}", updated);
        }
    }

    private void normalizeDemoSeedText() {
        jdbcTemplate.update("""
                UPDATE app_user
                SET display_name = '示范农户',
                    bio = '负责 A01 大棚日常巡检和出菇期管理',
                    password_hash = ?
                WHERE username = 'farmer001'
                """, "{bcrypt}" + passwordEncoder.encode("123456"));
        jdbcTemplate.update("""
                UPDATE greenhouse
                SET name = 'A01 羊肚菌智能大棚',
                    location = '温室一区 / 北侧',
                    crop_stage = '出菇期'
                WHERE id = 1
                """);
        jdbcTemplate.update("""
                UPDATE greenhouse_device
                SET name = '循环风机组',
                    category = '通风',
                    location = '东侧风道'
                WHERE id = 1
                """);
        jdbcTemplate.update("""
                UPDATE greenhouse_alert
                SET title = '湿度波动偏高',
                    description = '连续 8 分钟超过目标上限 3.5%，请检查加湿策略和通风设备。',
                    level = 'WARNING'
                WHERE id = 1
                """);
    }
}
