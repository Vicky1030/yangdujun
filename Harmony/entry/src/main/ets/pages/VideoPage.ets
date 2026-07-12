import { promptAction, router } from '@kit.ArkUI';
import { AndroidColor } from '../common/AndroidStyle';

@Entry
@Component
struct VideoPage {
  @State showOverlay: boolean = false;
  @State overlayText: string = '';
  @State status: string = '监控运行中';

  // Video 始终自动循环播放，遮罩层模拟暂停/停止效果

  build() {
    Stack() {
      Circle()
        .width(300)
        .height(300)
        .fill(AndroidColor.GREEN_SOFT)
        .opacity(0.1)
        .position({ x: -60, y: 640 })

      Column() {
        Row() {
          Button('返回')
            .width(70)
            .height(36)
            .fontSize(13)
            .fontColor(Color.White)
            .backgroundColor('#6F9F62')
            .borderRadius(18)
            .onClick(() => router.back())
          Text('大棚视频监控')
            .layoutWeight(1)
            .fontSize(21)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
          Blank()
            .width(70)
        }
        .width('100%')
        .height(62)
        .padding({ left: 14, right: 14 })
        .backgroundColor(AndroidColor.GREEN_HEADER)
        .borderRadius(14)
        .shadow({ radius: 5, color: '#22000000', offsetX: 0, offsetY: 2 })
        .margin({ bottom: 12 })

        Stack() {
          Video({
            src: $rawfile('gu.mp4')
          })
            .width('100%')
            .height(220)
            .objectFit(ImageFit.Cover)
            .autoPlay(true)
            .loop(true)
            .controls(true)
            .borderRadius(14)
            .onError(() => {
              promptAction.showToast({ message: '视频解码失败，编码格式不兼容' });
            })

          // LIVE 指示器
          if (!this.showOverlay) {
            Row({ space: 4 }) {
              Circle()
                .width(8)
                .height(8)
                .fill('#4CAF50')
              Text('LIVE')
                .fontSize(11)
                .fontColor(Color.White)
            }
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor('#66000000')
            .borderRadius(10)
            .position({ x: 8, y: 8 })
          }

          // 暂停/停止遮罩
          if (this.showOverlay) {
            Column({ space: 8 }) {
              Text(this.overlayText.length > 0 ? this.overlayText : '⏸')
                .fontSize(48)
                .fontColor('#FFFFFF')
                .opacity(0.9)
              Text(this.status)
                .fontSize(14)
                .fontColor('#FFFFFF')
                .opacity(0.9)
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .width('100%')
            .height(220)
            .backgroundColor('#CC333333')
            .borderRadius(14)
          }
        }
        .width('100%')
        .height(236)
        .margin({ bottom: 16 })
        .shadow({ radius: 6, color: '#33000000', offsetX: 0, offsetY: 2 })

        Row({ space: 10 }) {
          Button('播放')
            .layoutWeight(1)
            .height(45)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#4CAF50')
            .borderRadius(12)
            .onClick(() => {
              this.showOverlay = false;
              this.status = '监控运行中';
            })
          Button('暂停监控')
            .layoutWeight(1)
            .height(45)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#4CAF50')
            .borderRadius(12)
            .onClick(() => {
              this.showOverlay = true;
              this.overlayText = '⏸';
              this.status = '监控已暂停';
            })
          Button('重新播放')
            .layoutWeight(1)
            .height(45)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#4CAF50')
            .borderRadius(12)
            .onClick(() => {
              this.showOverlay = false;
              this.status = '监控运行中';
            })
        }
        .margin({ bottom: 12 })

        Button('停止监控')
          .width('100%')
          .height(45)
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor('#C64B4B')
          .borderRadius(12)
          .margin({ bottom: 16 })
          .onClick(() => {
            this.showOverlay = true;
            this.overlayText = '⏹';
            this.status = '监控已停止';
          })

        Text(`状态：${this.status}`)
          .width('100%')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(AndroidColor.GREEN_LABEL)
          .textAlign(TextAlign.Center)
          .padding(16)
          .backgroundColor('#C8D6C5')
          .borderRadius(8)
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
