package com.morel.greenhouse.infrastructure.repository;

import com.morel.greenhouse.application.port.GreenhouseRepository;
import com.morel.greenhouse.application.dto.AlertDetail;
import com.morel.greenhouse.domain.alert.AlertLevel;
import com.morel.greenhouse.domain.alert.AlertStatus;
import com.morel.greenhouse.domain.alert.GreenhouseAlert;
import com.morel.greenhouse.domain.device.Device;
import com.morel.greenhouse.domain.device.DeviceStatus;
import com.morel.greenhouse.domain.greenhouse.Greenhouse;
import com.morel.greenhouse.domain.greenhouse.GreenhouseStatus;
import com.morel.greenhouse.domain.telemetry.TelemetrySnapshot;
import com.morel.greenhouse.domain.traceability.TraceabilityRecord;
import com.morel.greenhouse.domain.user.OperatorProfile;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
@Profile("mock-data")
public class MockGreenhouseRepository implements GreenhouseRepository {

    @Override
    public List<Greenhouse> findGreenhouses() {
        return List.of(
                new Greenhouse(1L, "A01 智能育菇棚", "温室一区 / 北侧", GreenhouseStatus.ONLINE, 420.0, "出菇期"),
                new Greenhouse(2L, "B03 恒湿试验棚", "温室二区 / 东侧", GreenhouseStatus.WARNING, 360.0, "菌丝恢复期"),
                new Greenhouse(3L, "C02 低温培育棚", "温室三区 / 西侧", GreenhouseStatus.ONLINE, 500.0, "采收期")
        );
    }

    @Override
    public Optional<TelemetrySnapshot> findCurrentTelemetry(Long greenhouseId) {
        return Optional.of(new TelemetrySnapshot(
                greenhouseId,
                21.8,
                84.6,
                4280,
                790,
                62.5,
                LocalDateTime.now().minusSeconds(12)
        ));
    }

    @Override
    public List<Device> findDevices(Long greenhouseId) {
        return List.of(
                new Device(1001L, greenhouseId, "循环风机组", "通风", DeviceStatus.RUNNING, "东侧风道", true, 96),
                new Device(1002L, greenhouseId, "雾化加湿阵列", "湿度", DeviceStatus.RUNNING, "顶部管线", true, 92),
                new Device(1003L, greenhouseId, "补光灯带", "光照", DeviceStatus.STOPPED, "中轴棚架", false, 89),
                new Device(1004L, greenhouseId, "二氧化碳阀组", "气体", DeviceStatus.MAINTENANCE, "南侧设备间", false, 73)
        );
    }

    @Override
    public List<GreenhouseAlert> findAlerts(Long greenhouseId) {
        return List.of(
                new GreenhouseAlert(2001L, greenhouseId, "B 区湿度波动偏高", "连续 8 分钟超过目标上限 3.5%", AlertLevel.WARNING, AlertStatus.OPEN, LocalDateTime.now().minusMinutes(9)),
                new GreenhouseAlert(2002L, greenhouseId, "补光灯带离线", "设备 1003 已切换为手动巡检状态", AlertLevel.INFO, AlertStatus.ACKNOWLEDGED, LocalDateTime.now().minusHours(1)),
                new GreenhouseAlert(2003L, greenhouseId, "CO2 阀组保养提醒", "建议在 24 小时内完成阀组校准", AlertLevel.CRITICAL, AlertStatus.OPEN, LocalDateTime.now().minusHours(3))
        );
    }

    @Override
    public List<AlertDetail> findAlertDetails(Long greenhouseId) {
        return findAlerts(greenhouseId).stream()
                .map(alert -> new AlertDetail(alert.id(), alert.greenhouseId(), "示例大棚", null, "未绑定设备",
                        alert.title(), alert.description(), alert.level().name(), alert.status().name(), alert.occurredAt()))
                .toList();
    }

    @Override
    public List<TraceabilityRecord> findTraceabilityRecords(Long greenhouseId) {
        return List.of(
                new TraceabilityRecord(3001L, greenhouseId, "ML-202606-A01", "基质入棚", "张工", LocalDate.now().minusDays(28), "完成批次建档与二维码绑定"),
                new TraceabilityRecord(3002L, greenhouseId, "ML-202606-A01", "温湿度策略调整", "李工", LocalDate.now().minusDays(12), "夜间湿度目标上调至 86%"),
                new TraceabilityRecord(3003L, greenhouseId, "ML-202606-A01", "巡检采样", "王工", LocalDate.now().minusDays(2), "抽检 12 个点位，长势均衡")
        );
    }

    @Override
    public Optional<OperatorProfile> findOperator(String username) {
        return Optional.of(new OperatorProfile(1L, username, "系统管理员", "13800000000", "园区管理员", "智慧农业示范基地"));
    }
}
