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
        populator.addScript(new ClassPathResource("db/kingbase/schema.sql"));
        populator.addScript(new ClassPathResource("db/kingbase/seed.sql"));
        populator.execute(dataSource);

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
}
