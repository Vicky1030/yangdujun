package com.smartgreenhouse.backend.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class Database {
    private Database() {
    }

    public static Connection open() throws SQLException {
        try {
            Class.forName("com.kingbase8.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("KingbaseES JDBC driver not found. Put kingbase8.jar in backend/lib.", ex);
        }

        String url = requiredEnv("KINGBASE_URL");
        String username = requiredEnv("KINGBASE_USERNAME");
        String password = requiredEnv("KINGBASE_PASSWORD");
        DriverManager.setLoginTimeout(8);
        return DriverManager.getConnection(url, username, password);
    }

    private static String requiredEnv(String name) throws SQLException {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty()) {
            throw new SQLException("Missing required environment variable: " + name);
        }
        return value.trim();
    }
}
