import { promptAction, router } from '@kit.ArkUI';
import { AppRoutes } from '../common/AppRoutes';
import { AlarmRecord, Device, Greenhouse } from '../models/AppModels';
import { AppService, DeviceCommandAction } from '../services/AppService';

interface SelectItem {
  value: string;
}

interface OperationItem {
  value: string;
  code: string;
}

@Entry
@Component
struct AlarmHandlePage {
  @State greenhouseIndex: number = 0;
  @State deviceIndex: number = 0;
  @State operateIndex: number = 0;
  @State alarm: AlarmRecord = {
    id: '',
    greenhouseId: 'default',
    greenhouseName: '默认大棚',
    device: '环境传感器',
    title: '暂无告警',
    content: '当前没有需要处理的告警。',
    level: '低',
    status: '未处理',
    createdAt: ''
  };
  @State greenhouses: Greenhouse[] = AppService.getGreenhouses();
  @State deviceList: Device[] = [];
  @State sending: boolean = false;

  private operations: OperationItem[] = [
    { value: '开启风机', code: 'fan_on' },
    { value: '关闭风机', code: 'fan_off' },
    { value: '开启水泵', code: 'water_on' },
    { value: '关闭水泵', code: 'water_off' },
    { value: '开启补光灯', code: 'light_on' },
    { value: '关闭补光灯', code: 'light_off' },
    { value: '开启遮光板', code: 'board_on' },
    { value: '关闭遮光板', code: 'board_off' },
    { value: '关闭所选设备', code: 'device_off' }
  ];

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    const alarmId = params && params.alarmId ? params.alarmId : '';
    const alarm = alarmId.length > 0 ? AppService.getAlarmById(alarmId) : null;
    if (alarm) {
      this.alarm = alarm;
      this.syncGreenhouseIndex(alarm.greenhouseId);
      this.applySuggestedAction();
    }

    AppService.refreshGreenhousesFromDatabase().then((items: Greenhouse[]) => {
      this.greenhouses = items;
      this.syncGreenhouseIndex(this.alarm.greenhouseId);
      this.refreshDevices();
    }).catch(() => {
      this.refreshDevices();
    });
  }

  private currentGreenhouseId(): string {
    return this.alarm.greenhouseId || this.greenhouses[this.greenhouseIndex]?.id || 'default';
  }

  private syncGreenhouseIndex(greenhouseId: string): void {
    const index = this.greenhouses.findIndex((item: Greenhouse) => item.id === greenhouseId);
    this.greenhouseIndex = index >= 0 ? index : 0;
    this.deviceIndex = 0;
  }

  private isAlarmForCloudGreenhouse(): boolean {
    return AppService.canSendCloudCommand(this.alarm.greenhouseId);
  }

  private greenhouseOptions(): SelectItem[] {
    const options: SelectItem[] = [];
    for (let i = 0; i < this.greenhouses.length; i++) {
      options.push({ value: this.greenhouses[i].name });
    }
    return options.length > 0 ? options : [{ value: this.alarm.greenhouseName }];
  }

  private devices(): Device[] {
    if (this.deviceList.length > 0) {
      return this.deviceList;
    }
    return AppService.getDevices(this.currentGreenhouseId());
  }

  private refreshDevices(): void {
    AppService.refreshDevicesFromDatabase(this.currentGreenhouseId()).then((items: Device[]) => {
      this.deviceList = items;
      this.applySuggestedAction();
    }).catch(() => {
      this.deviceList = AppService.getDevices(this.currentGreenhouseId());
      this.applySuggestedAction();
    });
  }

  private deviceOptions(): SelectItem[] {
    const devices = this.devices();
    const options: SelectItem[] = [];
    for (let i = 0; i < devices.length; i++) {
      options.push({ value: devices[i].name });
    }
    return options.length > 0 ? options : [{ value: this.alarm.device }];
  }

  private operationOptions(): SelectItem[] {
    const options: SelectItem[] = [];
    for (let i = 0; i < this.operations.length; i++) {
      options.push({ value: this.operations[i].value });
    }
    return options;
  }

  private selectedDeviceType(): string {
    const devices = this.devices();
    if (this.deviceIndex >= 0 && this.deviceIndex < devices.length) {
      return devices[this.deviceIndex].type;
    }
    return AppService.suggestAlarmDeviceAction(this.alarm).deviceType;
  }

  private applySuggestedAction(): void {
    const suggested = AppService.suggestAlarmDeviceAction(this.alarm);
    const devices = this.devices();
    const deviceIndex = devices.findIndex((item: Device) => item.type === suggested.deviceType);
    if (deviceIndex >= 0) {
      this.deviceIndex = deviceIndex;
    }

    for (let i = 0; i < this.operations.length; i++) {
      const action = AppService.buildDeviceAction(suggested.deviceType, this.operations[i].code);
      if (action && action.commandName === suggested.commandName && action.value === suggested.value) {
        this.operateIndex = i;
        return;
      }
    }
  }

  private selectedAction(): DeviceCommandAction | null {
    const operation = this.operations[this.operateIndex];
    if (!operation) {
      return null;
    }
    return AppService.buildDeviceAction(this.selectedDeviceType(), operation.code);
  }

  private nowText(): string {
    return new Date().toLocaleString();
  }

  private async submit(): Promise<void> {
    if (this.sending) {
      return;
    }
    if (this.alarm.id.length === 0) {
      promptAction.showToast({ message: '当前没有可处理的告警' });
      return;
    }

    const greenhouseId = this.alarm.greenhouseId;
    if (!this.isAlarmForCloudGreenhouse()) {
      promptAction.showToast({ message: '当前大棚未绑定云端设备，不能下发真实命令' });
      return;
    }

    const action = this.selectedAction();
    if (!action) {
      promptAction.showToast({ message: '请选择可下发的设备控制命令' });
      return;
    }

    this.sending = true;
    const commandOk = await AppService.sendDeviceAction(greenhouseId, action);
    if (!commandOk) {
      this.sending = false;
      promptAction.showToast({ message: '命令下发失败，告警未处理' });
      return;
    }

    const alarmOk = await AppService.handleAlarmWithDatabase(this.alarm.id);
    this.sending = false;
    if (!alarmOk) {
      promptAction.showToast({ message: '命令已下发，但告警状态更新失败' });
      return;
    }

    promptAction.showToast({ message: '命令已下发，告警处理完成' });
    router.replaceUrl({ url: AppRoutes.ALARM_DETAIL, params: { alarmId: this.alarm.id } });
  }

  @Builder
  Header() {
    Row() {
      Button('返回')
        .width(70)
        .height(36)
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#9DBF80')
        .borderRadius(18)
        .onClick(() => router.back())
      Text('告警处理')
        .layoutWeight(1)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ right: 70 })
    }
    .width('100%')
    .height(75)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#A8C69F')
    .borderRadius(30)
    .shadow({ radius: 10, color: '#33000000', offsetX: 0, offsetY: 3 })
  }

  @Builder
  InfoLine(label: string, value: string, bold: boolean = false) {
    Column({ space: 4 }) {
      Text(label)
        .fontSize(12)
        .fontColor('#9EBA95')
      Text(value)
        .fontSize(bold ? 16 : 15)
        .fontWeight(bold ? FontWeight.Bold : FontWeight.Regular)
        .fontColor('#4A6142')
        .lineHeight(21)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  @Builder
  AlarmInfoCard() {
    Column({ space: 12 }) {
      this.InfoLine('告警位置', `${this.alarm.greenhouseName}${this.alarm.device}`, true)
      this.InfoLine('告警策略', this.alarm.title)
      this.InfoLine('告警详情', this.alarm.content)
      Divider().color('#F0F5EF')
      Row() {
        Text('告警时间')
          .fontSize(14)
          .fontColor('#9EBA95')
        Blank()
        Text(this.alarm.createdAt)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#4A6142')
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(26)
    .shadow({ radius: 4, color: '#22000000', offsetX: 0, offsetY: 2 })
    .margin({ bottom: 16 })
  }

  @Builder
  SelectRow(label: string, options: SelectItem[], index: number, kind: string) {
    Row() {
      Text(`● ${label}`)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#6BA878')
      Select(options)
        .selected(index)
        .value(options[index]?.value || '')
        .layoutWeight(1)
        .height(48)
        .margin({ left: 12 })
        .onSelect((selected: number) => {
          if (kind === 'greenhouse') {
            this.greenhouseIndex = selected;
            this.deviceIndex = 0;
            this.refreshDevices();
          } else if (kind === 'device') {
            this.deviceIndex = selected;
          } else {
            this.operateIndex = selected;
          }
        })
    }
    .width('100%')
    .margin({ top: kind === 'greenhouse' ? 0 : 12 })
  }

  @Builder
  OperateCard() {
    Column({ space: 16 }) {
      Text('● 执行真实设备命令')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#5A7D54')
      this.SelectRow('请选择大棚', this.greenhouseOptions(), this.greenhouseIndex, 'greenhouse')
      this.SelectRow('请选择设备', this.deviceOptions(), this.deviceIndex, 'device')
      this.SelectRow('拟执行操作', this.operationOptions(), this.operateIndex, 'operate')
    }
    .width('100%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(26)
    .shadow({ radius: 4, color: '#22000000', offsetX: 0, offsetY: 2 })
    .margin({ bottom: 16 })
  }

  @Builder
  SubmitTimeCard() {
    Row() {
      Text('提交时间')
        .fontSize(14)
        .fontColor('#9EBA95')
      Blank()
      Text(this.nowText())
        .fontSize(14)
        .fontColor('#4A6142')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#F8FCF7')
    .borderRadius(26)
    .margin({ bottom: 32 })
  }

  build() {
    Stack() {
      Column()
        .width(300)
        .height(300)
        .backgroundColor('#A8C69F')
        .opacity(0.15)
        .borderRadius(150)
        .position({ x: 210, y: -50 })
      Column()
        .width(150)
        .height(150)
        .backgroundColor('#A8C69F')
        .opacity(0.08)
        .borderRadius(75)
        .position({ x: -30, y: 610 })

      Column({ space: 16 }) {
        this.Header()
        Scroll() {
          Column() {
            this.AlarmInfoCard()
            this.OperateCard()
            this.SubmitTimeCard()
          }
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        Button(this.sending ? '正在下发命令...' : '确认下发并处理告警')
          .width('100%')
          .height(60)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(this.sending ? '#B8C8B2' : '#A8C69F')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#33000000', offsetX: 0, offsetY: 3 })
          .margin({ bottom: 8 })
          .enabled(!this.sending && this.isAlarmForCloudGreenhouse())
          .onClick(() => {
            this.submit();
          })
      }
      .width('100%')
      .height('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#E9F2E6')
  }
}
