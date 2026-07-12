package com.smartgreenhouse.backend.service;

import com.smartgreenhouse.backend.db.Database;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

class AuthServiceDatabaseTest {
    private final AuthService service = new AuthService();

    @Test
    void loginFarmerShouldReturnUserWhenAppUserPasswordMatchesPlainText() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getString("id")).thenReturn("5");
        when(rs.getString("username")).thenReturn("farmer001");
        when(rs.getString("phone")).thenReturn("13800138000");
        when(rs.getString("display_name")).thenReturn("tester");
        when(rs.getString("password_hash")).thenReturn("abc12345");

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.loginFarmer("farmer001", "abc12345");
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"phone\":\"13800138000\""));
        }
    }

    @Test
    void registerFarmerShouldInsertWhenFarmerDoesNotExist() throws Exception {
        Connection existsConnection = mock(Connection.class);
        PreparedStatement existsStatement = mock(PreparedStatement.class);
        ResultSet existsRs = mock(ResultSet.class);
        when(existsConnection.prepareStatement(anyString())).thenReturn(existsStatement);
        when(existsStatement.executeQuery()).thenReturn(existsRs);
        when(existsRs.next()).thenReturn(false);

        Connection insertConnection = mock(Connection.class);
        PreparedStatement insertStatement = mock(PreparedStatement.class);
        when(insertConnection.prepareStatement(anyString())).thenReturn(insertStatement);
        when(insertStatement.executeUpdate()).thenReturn(1);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(existsConnection, insertConnection);
            assertTrue(service.registerFarmer("13800138000", "abc12345").contains("\"success\":true"));
        }
    }

    @Test
    void registerFarmerShouldRejectExistingAccount() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.registerFarmer("13800138000", "abc12345");
            assertTrue(result.contains("\"success\":false"));
            assertTrue(result.contains("account already exists"));
        }
    }

    @Test
    void resetFarmerPasswordShouldReturnWhetherRowWasUpdated() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeUpdate()).thenReturn(1);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            assertTrue(service.resetFarmerPassword("13800138000", "abc12345").contains("\"success\":true"));
        }
    }

    @Test
    void updateFarmerProfileShouldUpdateNumericUserId() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeUpdate()).thenReturn(1);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.updateFarmerProfile("5", "tester", "13800138000", "avatar.png");
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"nickname\":\"tester\""));
        }
    }
}
