package com.smartgreenhouse.backend.service;

import com.smartgreenhouse.backend.db.Database;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

class GreenhouseServiceDatabaseTest {
    private final GreenhouseService service = new GreenhouseService();

    @Test
    void checkDatabaseShouldReturnSuccessWhenSelectOneWorks() throws Exception {
        Connection connection = mock(Connection.class);
        Statement statement = mock(Statement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.createStatement()).thenReturn(statement);
        when(statement.executeQuery("select 1")).thenReturn(rs);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            assertTrue(service.checkDatabase().contains("\"success\":true"));
        }
    }

    @Test
    void checkDatabaseShouldReturnFailureWhenStatementFails() throws Exception {
        Connection connection = mock(Connection.class);
        when(connection.createStatement()).thenThrow(new SQLException("db down"));

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            assertTrue(service.checkDatabase().contains("\"success\":false"));
        }
    }

    @Test
    void listTablesShouldIncludeRowCounts() throws Exception {
        Connection connection = mock(Connection.class);
        Statement tablesStatement = mock(Statement.class);
        Statement countStatement = mock(Statement.class);
        ResultSet tables = mock(ResultSet.class);
        ResultSet count = mock(ResultSet.class);
        when(connection.createStatement()).thenReturn(tablesStatement, countStatement);
        when(tablesStatement.executeQuery(anyString())).thenReturn(tables);
        when(tables.next()).thenReturn(true, false);
        when(tables.getString("table_schema")).thenReturn("public");
        when(tables.getString("table_name")).thenReturn("greenhouse");
        when(countStatement.executeQuery(anyString())).thenReturn(count);
        when(count.next()).thenReturn(true);
        when(count.getLong(1)).thenReturn(10L);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.listTables();
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"name\":\"greenhouse\""));
            assertTrue(result.contains("\"rows\":10"));
        }
    }

    @Test
    void listGreenhousesShouldSerializeDatabaseRows() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true, false);
        when(rs.getString("id")).thenReturn("1");
        when(rs.getString("name")).thenReturn("A01");
        when(rs.getString("location")).thenReturn("North");
        when(rs.getString("area")).thenReturn("420");
        when(rs.getString("stage")).thenReturn("fruiting");

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.listGreenhouses("5");
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"name\":\"A01\""));
        }
    }

    @Test
    void latestSensorShouldSerializeSensorSnapshot() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        sensorRow(rs);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.latestSensor("1");
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"airTemperature\":18.5"));
            assertTrue(result.contains("\"lightOn\":true"));
        }
    }

    @Test
    void sensorHistoryShouldSerializeHistoryRows() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true, false);
        when(rs.getString("greenhouse_id")).thenReturn("1");
        when(rs.getString("time")).thenReturn("2026-07-03 10:00");
        sensorRow(rs);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.sensorHistory("0", 24);
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"temperature\":18.5"));
        }
    }

    @Test
    void listDevicesShouldSerializeDeviceRows() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true, false);
        when(rs.getString("id")).thenReturn("7");
        when(rs.getString("name")).thenReturn("Fan");
        when(rs.getString("category")).thenReturn("FAN");
        when(rs.getString("status")).thenReturn("RUNNING");

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.listDevices("abc");
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"type\":\"fan\""));
            assertTrue(result.contains("\"enabled\":true"));
        }
    }

    @Test
    void listAlarmsAndHandleAlarmShouldUseDatabaseState() throws Exception {
        Connection listConnection = mock(Connection.class);
        PreparedStatement listStatement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(listConnection.prepareStatement(anyString())).thenReturn(listStatement);
        when(listStatement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true, false);
        when(rs.getString("id")).thenReturn("alarm-1");
        when(rs.getString("greenhouse_id")).thenReturn("1");
        when(rs.getString("greenhouse_name")).thenReturn("A01");
        when(rs.getString("device")).thenReturn("sensor");
        when(rs.getString("title")).thenReturn("warning");
        when(rs.getString("description")).thenReturn("desc");
        when(rs.getString("level")).thenReturn("INFO");
        when(rs.getString("status")).thenReturn("ACTIVE");
        when(rs.getString("occurred_at")).thenReturn("now");
        when(rs.getString("handled_at")).thenReturn("");
        when(rs.getString("handled_by")).thenReturn("");

        Connection updateConnection = mock(Connection.class);
        PreparedStatement updateStatement = mock(PreparedStatement.class);
        when(updateConnection.prepareStatement(anyString())).thenReturn(updateStatement);
        when(updateStatement.executeUpdate()).thenReturn(1);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(listConnection, updateConnection);
            assertTrue(service.listAlarms("").contains("\"id\":\"alarm-1\""));
            assertTrue(service.handleAlarm("1", "tester").contains("\"success\":true"));
        }
    }

    @Test
    void thresholdShouldApplyDatabaseRules() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true, false);
        when(rs.getString("metric_key")).thenReturn("air_temperature");
        when(rs.getString("operator")).thenReturn("LT");
        when(rs.getDouble("threshold_value")).thenReturn(12.0);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.threshold("0");
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"tempMin\":12.0"));
        }
    }

    @Test
    void submitFeedbackCreateAndDeleteGreenhouseShouldHandleSuccessPaths() throws Exception {
        Connection feedbackConnection = updateConnection(1);
        Connection createConnection = updateConnection(1);
        Connection listConnection = listGreenhouseConnection();
        Connection deleteConnection = updateConnection(1);

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(feedbackConnection, createConnection, listConnection, deleteConnection);
            assertTrue(service.submitFeedback("5", "content", "phone").contains("\"success\":true"));
            assertTrue(service.createGreenhouse("5", "A02", "South", "123.5").contains("\"success\":true"));
            assertTrue(service.deleteGreenhouse("5", "1").contains("\"success\":true"));
        }
    }

    @Test
    void saveThresholdShouldUpsertAllRulesAndReturnSavedValues() throws Exception {
        Connection connection = mock(Connection.class);
        when(connection.prepareStatement(anyString())).thenAnswer(invocation -> {
            String sql = invocation.getArgument(0);
            if (sql.startsWith("select id from alert_rule")) {
                PreparedStatement select = mock(PreparedStatement.class);
                ResultSet rs = mock(ResultSet.class);
                when(select.executeQuery()).thenReturn(rs);
                when(rs.next()).thenReturn(false);
                return select;
            }
            if (sql.startsWith("insert into alert_rule")) {
                PreparedStatement insert = mock(PreparedStatement.class);
                when(insert.executeUpdate()).thenReturn(1);
                return insert;
            }
            throw new SQLException("stop sync after saving threshold rules");
        });

        String body = "{"
                + "\"tempMin\":12,\"tempMax\":26,\"airHumMin\":75,\"airHumMax\":90,"
                + "\"soilTempMin\":13,\"soilTempMax\":22,\"humMin\":60,\"humMax\":80,"
                + "\"co2Min\":420,\"co2Max\":1100,\"o2Min\":19,\"o2Max\":22,"
                + "\"phMin\":6.1,\"phMax\":7.2,\"lightMin\":1000,\"lightMax\":5000"
                + "}";

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            String result = service.saveThreshold("1", body);
            assertTrue(result.contains("\"success\":true"));
            assertTrue(result.contains("\"tempMin\":12.0"));
            assertTrue(result.contains("\"lightMax\":5000.0"));
        }
    }

    @Test
    void publicMethodsShouldReturnFailureOnSqlException() throws Exception {
        Connection connection = mock(Connection.class);
        when(connection.prepareStatement(anyString())).thenThrow(new java.sql.SQLException("boom"));

        try (MockedStatic<Database> database = mockStatic(Database.class)) {
            database.when(Database::open).thenReturn(connection);
            assertTrue(service.listDevices("abc").contains("\"success\":false"));
            assertTrue(service.handleAlarm("1", "tester").contains("\"success\":false"));
        }
    }

    private Connection updateConnection(int rows) throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeUpdate()).thenReturn(rows);
        return connection;
    }

    private Connection listGreenhouseConnection() throws Exception {
        Connection connection = mock(Connection.class);
        PreparedStatement statement = mock(PreparedStatement.class);
        ResultSet rs = mock(ResultSet.class);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true, false);
        when(rs.getString("id")).thenReturn("2");
        when(rs.getString("name")).thenReturn("A02");
        when(rs.getString("location")).thenReturn("South");
        when(rs.getString("area")).thenReturn("123.5");
        when(rs.getString("stage")).thenReturn("fruiting");
        return connection;
    }

    private void sensorRow(ResultSet rs) throws Exception {
        when(rs.getDouble("air_temperature")).thenReturn(18.5);
        when(rs.getDouble("air_humidity")).thenReturn(85.0);
        when(rs.getDouble("soil_temperature")).thenReturn(17.0);
        when(rs.getDouble("soil_humidity")).thenReturn(70.0);
        when(rs.getDouble("light")).thenReturn(1200.0);
        when(rs.getDouble("co2")).thenReturn(680.0);
        when(rs.getDouble("o2")).thenReturn(20.8);
        when(rs.getDouble("ph")).thenReturn(6.8);
        when(rs.getDouble("distance")).thenReturn(-1.0);
        when(rs.getInt("fan_gear")).thenReturn(2);
        when(rs.getBoolean("light_on")).thenReturn(true);
        when(rs.getBoolean("board_on")).thenReturn(false);
        when(rs.getBoolean("water_pump_on")).thenReturn(true);
        when(rs.getBoolean("medicine_pump_on")).thenReturn(false);
        when(rs.getString("ai_warning")).thenReturn("normal");
        when(rs.getInt("growth_stage")).thenReturn(4);
        when(rs.getString("updated_at")).thenReturn("2026-07-03 10:00");
    }
}
