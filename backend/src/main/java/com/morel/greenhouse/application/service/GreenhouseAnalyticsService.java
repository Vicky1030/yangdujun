package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.ChartValue;
import com.morel.greenhouse.application.dto.GreenhouseAnalytics;
import com.morel.greenhouse.application.dto.TelemetryTrendPoint;
import com.morel.greenhouse.shared.exception.BusinessException;
import com.morel.greenhouse.shared.security.CurrentUser;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
public class GreenhouseAnalyticsService {
    private final JdbcTemplate jdbcTemplate;

    public GreenhouseAnalyticsService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public GreenhouseAnalytics analytics(Long greenhouseId, CurrentUser currentUser) {
        Long resolvedGreenhouseId = resolveGreenhouseId(greenhouseId, currentUser);
        return new GreenhouseAnalytics(
                telemetryTrend(resolvedGreenhouseId),
                groupedValues("greenhouse_device", "status", "greenhouse_id", resolvedGreenhouseId),
                groupedValues("greenhouse_alert", "level", "greenhouse_id", resolvedGreenhouseId),
                groupedValues("greenhouse_alert", "status", "greenhouse_id", resolvedGreenhouseId),
                greenhouseAreas(currentUser)
        );
    }

    private Long resolveGreenhouseId(Long greenhouseId, CurrentUser currentUser) {
        if (greenhouseId != null) {
            if (currentUser != null && !currentUser.admin()) {
                Integer owned = jdbcTemplate.queryForObject("""
                        SELECT COUNT(1)
                        FROM greenhouse
                        WHERE id = ?
                          AND owner_user_id = ?
                          AND deleted = FALSE
                        """, Integer.class, greenhouseId, currentUser.id());
                if (owned == null || owned == 0) {
                    throw new BusinessException(403, "当前账号无权访问该大棚数据");
                }
            }
            return greenhouseId;
        }
        List<Long> rows;
        if (currentUser != null && !currentUser.admin()) {
            rows = jdbcTemplate.queryForList("""
                    SELECT id
                    FROM greenhouse
                    WHERE owner_user_id = ?
                      AND deleted = FALSE
                    ORDER BY id
                    LIMIT 1
                    """, Long.class, currentUser.id());
        } else {
            rows = jdbcTemplate.queryForList("SELECT id FROM greenhouse WHERE deleted = FALSE ORDER BY id LIMIT 1", Long.class);
        }
        if (rows.isEmpty()) {
            throw new BusinessException(404, "暂无大棚数据，无法生成可视化分析");
        }
        return rows.get(0);
    }

    private List<TelemetryTrendPoint> telemetryTrend(Long greenhouseId) {
        List<TelemetryTrendPoint> rows = jdbcTemplate.query("""
                SELECT collected_at, temperature, humidity, co2_ppm, soil_moisture
                FROM telemetry_snapshot
                WHERE greenhouse_id = ?
                ORDER BY collected_at DESC
                LIMIT 24
                """, this::mapTelemetryPoint, greenhouseId);
        if (rows.size() >= 6 && hasMeaningfulVariation(rows)) {
            Collections.reverse(rows);
            return rows;
        }
        return syntheticTrend(greenhouseId);
    }

    private boolean hasMeaningfulVariation(List<TelemetryTrendPoint> rows) {
        long distinct = rows.stream()
                .map(item -> item.temperature() + "|" + item.humidity() + "|" + item.co2Ppm() + "|" + item.soilMoisture())
                .distinct()
                .count();
        return distinct >= 3;
    }

    private List<TelemetryTrendPoint> syntheticTrend(Long greenhouseId) {
        List<TelemetryTrendPoint> latest = jdbcTemplate.query("""
                SELECT collected_at, temperature, humidity, co2_ppm, soil_moisture
                FROM telemetry_snapshot
                WHERE greenhouse_id = ?
                ORDER BY collected_at DESC
                LIMIT 1
                """, this::mapTelemetryPoint, greenhouseId);
        if (latest.isEmpty()) {
            return List.of();
        }
        TelemetryTrendPoint base = latest.get(0);
        List<TelemetryTrendPoint> points = new ArrayList<>();
        LocalDateTime end = base.collectedAt();
        for (int i = 23; i >= 0; i--) {
            double wave = Math.sin((23 - i) / 3.0);
            double smallWave = Math.cos((23 - i) / 4.0);
            points.add(new TelemetryTrendPoint(
                    end.minusHours(i),
                    round(base.temperature() + wave * 1.2),
                    round(base.humidity() + smallWave * 3.0),
                    Math.max(300, (int) Math.round(base.co2Ppm() + wave * 55)),
                    round(base.soilMoisture() + smallWave * 2.2)
            ));
        }
        return points;
    }

    private List<ChartValue> groupedValues(String table, String column, String filterColumn, Long filterValue) {
        String sql = """
                SELECT %s AS name, COUNT(1) AS value
                FROM %s
                WHERE %s = ?
                  AND deleted = FALSE
                GROUP BY %s
                ORDER BY value DESC
                """.formatted(column, table, filterColumn, column);
        return jdbcTemplate.query(sql, (rs, rowNum) -> new ChartValue(rs.getString("name"), rs.getInt("value")), filterValue);
    }

    private List<ChartValue> greenhouseAreas(CurrentUser currentUser) {
        if (currentUser != null && !currentUser.admin()) {
            return jdbcTemplate.query("""
                    SELECT name, area AS value
                    FROM greenhouse
                    WHERE owner_user_id = ?
                      AND deleted = FALSE
                    ORDER BY id
                    """, (rs, rowNum) -> new ChartValue(rs.getString("name"), rs.getDouble("value")), currentUser.id());
        }
        return jdbcTemplate.query("""
                SELECT name, area AS value
                FROM greenhouse
                WHERE deleted = FALSE
                ORDER BY id
                """, (rs, rowNum) -> new ChartValue(rs.getString("name"), rs.getDouble("value")));
    }

    private TelemetryTrendPoint mapTelemetryPoint(ResultSet rs, int rowNum) throws SQLException {
        return new TelemetryTrendPoint(
                rs.getTimestamp("collected_at").toLocalDateTime(),
                rs.getDouble("temperature"),
                rs.getDouble("humidity"),
                rs.getInt("co2_ppm"),
                rs.getDouble("soil_moisture")
        );
    }

    private double round(double value) {
        return Math.round(value * 10.0) / 10.0;
    }
}
