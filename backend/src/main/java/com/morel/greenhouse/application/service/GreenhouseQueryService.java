package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.DashboardOverview;
import com.morel.greenhouse.application.dto.AlertDetail;
import com.morel.greenhouse.application.dto.ProductionSummary;
import com.morel.greenhouse.application.port.GreenhouseRepository;
import com.morel.greenhouse.domain.alert.AlertStatus;
import com.morel.greenhouse.domain.alert.GreenhouseAlert;
import com.morel.greenhouse.domain.device.Device;
import com.morel.greenhouse.domain.device.DeviceStatus;
import com.morel.greenhouse.domain.greenhouse.Greenhouse;
import com.morel.greenhouse.domain.greenhouse.GreenhouseStatus;
import com.morel.greenhouse.domain.telemetry.TelemetrySnapshot;
import com.morel.greenhouse.domain.traceability.TraceabilityRecord;
import com.morel.greenhouse.shared.exception.BusinessException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GreenhouseQueryService {
    private final GreenhouseRepository repository;

    public GreenhouseQueryService(GreenhouseRepository repository) {
        this.repository = repository;
    }

    public List<Greenhouse> listGreenhouses() {
        return repository.findGreenhouses();
    }

    public DashboardOverview getOverview(Long greenhouseId) {
        Long resolvedGreenhouseId = resolveGreenhouseId(greenhouseId);
        List<Greenhouse> greenhouses = repository.findGreenhouses();
        TelemetrySnapshot telemetry = getTelemetry(resolvedGreenhouseId);
        List<Device> devices = repository.findDevices(resolvedGreenhouseId);
        List<GreenhouseAlert> activeAlerts = repository.findAlerts(resolvedGreenhouseId).stream()
                .filter(alert -> alert.status() != AlertStatus.RESOLVED)
                .toList();

        ProductionSummary summary = new ProductionSummary(
                (int) greenhouses.stream().filter(g -> g.status() != GreenhouseStatus.OFFLINE).count(),
                (int) devices.stream().filter(device -> device.status() == DeviceStatus.RUNNING).count(),
                activeAlerts.size(),
                1680.5,
                "A"
        );

        return new DashboardOverview(greenhouses, telemetry, devices, activeAlerts, summary);
    }

    public TelemetrySnapshot getTelemetry(Long greenhouseId) {
        return repository.findCurrentTelemetry(resolveGreenhouseId(greenhouseId))
                .orElseThrow(() -> new BusinessException(404, "greenhouse telemetry not found"));
    }

    public List<Device> listDevices(Long greenhouseId) {
        return repository.findDevices(resolveGreenhouseId(greenhouseId));
    }

    public List<GreenhouseAlert> listAlerts(Long greenhouseId) {
        return repository.findAlerts(resolveGreenhouseId(greenhouseId));
    }

    public List<AlertDetail> listAlertDetails(Long greenhouseId) {
        return repository.findAlertDetails(greenhouseId);
    }

    public List<TraceabilityRecord> listTraceabilityRecords(Long greenhouseId) {
        return repository.findTraceabilityRecords(resolveGreenhouseId(greenhouseId));
    }

    private Long resolveGreenhouseId(Long greenhouseId) {
        if (greenhouseId != null) {
            return greenhouseId;
        }
        return repository.findGreenhouses().stream()
                .findFirst()
                .map(Greenhouse::id)
                .orElseThrow(() -> new BusinessException(404, "greenhouse not found"));
    }
}
