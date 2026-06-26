package com.morel.greenhouse.interfaces.controller;

import com.morel.greenhouse.application.dto.AlertDetail;
import com.morel.greenhouse.application.dto.CreateDeviceRequest;
import com.morel.greenhouse.application.dto.CreateGreenhouseRequest;
import com.morel.greenhouse.application.dto.DashboardOverview;
import com.morel.greenhouse.application.dto.DeviceCommandRequest;
import com.morel.greenhouse.application.service.DeviceCommandService;
import com.morel.greenhouse.application.service.GreenhouseManagementService;
import com.morel.greenhouse.application.service.GreenhouseQueryService;
import com.morel.greenhouse.domain.alert.GreenhouseAlert;
import com.morel.greenhouse.domain.device.Device;
import com.morel.greenhouse.domain.greenhouse.Greenhouse;
import com.morel.greenhouse.domain.telemetry.TelemetrySnapshot;
import com.morel.greenhouse.domain.traceability.TraceabilityRecord;
import com.morel.greenhouse.shared.api.ApiResult;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/greenhouses")
public class GreenhouseController {
    private final GreenhouseQueryService queryService;
    private final DeviceCommandService deviceCommandService;
    private final GreenhouseManagementService managementService;

    public GreenhouseController(
            GreenhouseQueryService queryService,
            DeviceCommandService deviceCommandService,
            GreenhouseManagementService managementService
    ) {
        this.queryService = queryService;
        this.deviceCommandService = deviceCommandService;
        this.managementService = managementService;
    }

    @GetMapping
    public ApiResult<List<Greenhouse>> listGreenhouses() {
        return ApiResult.ok(queryService.listGreenhouses());
    }

    @PostMapping
    public ApiResult<Void> createGreenhouse(@Valid @RequestBody CreateGreenhouseRequest request) {
        managementService.createGreenhouse(request);
        return ApiResult.ok();
    }

    @GetMapping("/overview")
    public ApiResult<DashboardOverview> overview(@RequestParam(required = false) Long greenhouseId) {
        return ApiResult.ok(queryService.getOverview(greenhouseId));
    }

    @GetMapping("/telemetry")
    public ApiResult<TelemetrySnapshot> telemetry(@RequestParam(required = false) Long greenhouseId) {
        return ApiResult.ok(queryService.getTelemetry(greenhouseId));
    }

    @GetMapping("/devices")
    public ApiResult<List<Device>> devices(@RequestParam(required = false) Long greenhouseId) {
        return ApiResult.ok(queryService.listDevices(greenhouseId));
    }

    @PostMapping("/devices")
    public ApiResult<Void> createDevice(@Valid @RequestBody CreateDeviceRequest request) {
        managementService.createDevice(request);
        return ApiResult.ok();
    }

    @PostMapping("/devices/commands")
    public ApiResult<Void> command(@Valid @RequestBody DeviceCommandRequest request) {
        deviceCommandService.execute(request);
        return ApiResult.ok();
    }

    @GetMapping("/alerts")
    public ApiResult<List<GreenhouseAlert>> alerts(@RequestParam(required = false) Long greenhouseId) {
        return ApiResult.ok(queryService.listAlerts(greenhouseId));
    }

    @GetMapping("/alerts/detail")
    public ApiResult<List<AlertDetail>> alertDetails(@RequestParam(required = false) Long greenhouseId) {
        return ApiResult.ok(queryService.listAlertDetails(greenhouseId));
    }

    @GetMapping("/traceability")
    public ApiResult<List<TraceabilityRecord>> traceability(@RequestParam(required = false) Long greenhouseId) {
        return ApiResult.ok(queryService.listTraceabilityRecords(greenhouseId));
    }
}
