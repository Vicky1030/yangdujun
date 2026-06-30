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

        migrateDefaultAdmin();
        normalizeLegacyDeviceStatus();
        cleanupDebugAndCorruptedDevices();
        ensureDefaultAvatars();
        ensureUserRoleMappings();
    }

    private void migrateDefaultAdmin() {
        Integer admin1Exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM app_user WHERE username = 'admin1' AND deleted = FALSE",
                Integer.class
        );
        Integer legacyAdminExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM app_user WHERE username = 'admin' AND deleted = FALSE",
                Integer.class
        );
        if ((admin1Exists == null || admin1Exists == 0) && legacyAdminExists != null && legacyAdminExists > 0) {
            jdbcTemplate.update("""
                    UPDATE app_user
                    SET username = 'admin1',
                        display_name = NULL,
                        bio = '平台管理员',
                        allow_admin_delete = FALSE,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE username = 'admin' AND deleted = FALSE
                    """);
            log.info("Migrated default admin username from admin to admin1");
            return;
        }
        if (admin1Exists == null || admin1Exists == 0) {
            jdbcTemplate.update("""
                    INSERT INTO app_user(username, password_hash, role_code, phone, email, display_name, gender, bio, allow_admin_delete, created_by)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    "admin1",
                    "{bcrypt}" + passwordEncoder.encode(adminPassword),
                    "ADMIN",
                    "13800000000",
                    "admin1@example.com",
                    null,
                    "UNKNOWN",
                    "平台管理员",
                    false,
                    "system"
            );
            log.info("Admin account initialized: username=admin1");
        }
    }

    private void ensureUserRoleMappings() {
        jdbcTemplate.update("""
                INSERT INTO auth_user_role(user_id, role_id)
                SELECT u.id, r.id
                FROM app_user u, auth_role r
                WHERE u.role_code = r.role_code
                  AND u.deleted = FALSE
                  AND NOT EXISTS (SELECT 1 FROM auth_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id)
                """);
    }

    private void ensureDefaultAvatars() {
        int updated = jdbcTemplate.update("""
                UPDATE app_user
                SET avatar_url = CASE
                    WHEN role_code = 'ADMIN' AND gender = 'FEMALE' THEN '/avatars/female_admin.png'
                    WHEN role_code = 'ADMIN' THEN '/avatars/male_admin.png'
                    WHEN role_code = 'FARMER' AND gender = 'FEMALE' THEN '/avatars/female_farmer.png'
                    ELSE '/avatars/male_farmer.jpg'
                END,
                updated_at = CURRENT_TIMESTAMP
                WHERE deleted = FALSE
                  AND (avatar_url IS NULL OR TRIM(avatar_url) = '')
                """);
        if (updated > 0) {
            log.info("Default user avatars assigned: count={}", updated);
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

    private void cleanupDebugAndCorruptedDevices() {
        int removed = jdbcTemplate.update("""
                UPDATE greenhouse_device
                SET deleted = TRUE,
                    deleted_at = CURRENT_TIMESTAMP,
                    updated_at = CURRENT_TIMESTAMP,
                    deleted_by = 'system-cleanup'
                WHERE deleted = FALSE
                  AND (
                    name LIKE '%?%'
                    OR category LIKE '%?%'
                    OR location LIKE '%?%'
                    OR remark LIKE '%?%'
                    OR LOWER(name) LIKE 'farmer-device-%'
                    OR LOWER(name) LIKE 'admin-block-test%'
                    OR LOWER(category) IN ('test', 'debug', 'demo')
                  )
                """);
        if (removed > 0) {
            log.warn("Cleaned debug or corrupted device rows: count={}", removed);
        }
    }
}
