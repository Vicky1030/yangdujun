import { promptAction, router } from '@kit.ArkUI';
import { AndroidColor } from '../common/AndroidStyle';
import { AppService } from '../services/AppService';
import { AppState } from '../storage/AppState';
import { User } from '../models/AppModels';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';

@Entry
@Component
struct EditProfilePage {
  @State nickname: string = '';
  @State phone: string = '';
  @State avatarUri: string = '';
  @State isSaving: boolean = false;
  private initialNickname: string = '';
  private initialPhone: string = '';

  aboutToAppear(): void {
    const user: User | null = AppService.getCurrentUser();
    if (user) {
      this.nickname = user.nickname;
      this.phone = user.phone;
      this.avatarUri = user.avatar || '';
      this.initialNickname = user.nickname;
      this.initialPhone = user.phone;
    }
  }

  private async pickAvatar(): Promise<void> {
    try {
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;

      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      const result = await photoPicker.select(photoSelectOptions);

      if (result.photoUris.length > 0) {
        const uri = result.photoUris[0];
        // 将图片复制到应用沙箱目录并获取持久化路径
        const context = getContext(this);
        const fileName = `avatar_${Date.now()}.jpg`;
        const targetPath = `${context.cacheDir}/${fileName}`;

        try {
          const sourceFile = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
          const targetFile = fileIo.openSync(targetPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
          const bufferSize = 4096;
          const buffer = new ArrayBuffer(bufferSize);
          let readLen = 0;
          while ((readLen = fileIo.readSync(sourceFile.fd, buffer)) > 0) {
            fileIo.writeSync(targetFile.fd, buffer, { length: readLen });
          }
          fileIo.closeSync(sourceFile);
          fileIo.closeSync(targetFile);

          // 压缩图片到合适大小
          const imageSource = image.createImageSource(uri);
          const decodeOpts: image.DecodingOptions = {
            desiredSize: { width: 256, height: 256 }
          };
          const pixelMap = await imageSource.createPixelMap(decodeOpts);
          const packOpts: image.PackingOption = {
            format: 'image/jpeg',
            quality: 80
          };
          const packedImage = await image.createImagePacker().packing(pixelMap, packOpts);
          const compressedPath = `${context.cacheDir}/avatar_thumb_${Date.now()}.jpg`;
          const compressedFile = fileIo.openSync(compressedPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
          fileIo.writeSync(compressedFile.fd, packedImage);
          fileIo.closeSync(compressedFile);

          this.avatarUri = compressedPath;
          promptAction.showToast({ message: '头像已选择' });
        } catch (copyErr) {
          // 如果复制失败，直接使用原 URI
          this.avatarUri = uri;
          promptAction.showToast({ message: '头像已选择' });
        }
      }
    } catch (err) {
      promptAction.showToast({ message: '选择图片失败，请重试' });
    }
  }

  private async save(): Promise<void> {
    if (this.nickname.trim().length === 0) {
      promptAction.showToast({ message: '昵称不能为空' });
      return;
    }
    if (this.phone.length > 0 && !/^1\d{10}$/.test(this.phone)) {
      promptAction.showToast({ message: '请输入正确的手机号码' });
      return;
    }
    if (this.isSaving) {
      return;
    }
    this.isSaving = true;
    try {
      const ok = await AppService.updateProfileToDatabase(
        this.nickname.trim(),
        this.phone.trim(),
        this.avatarUri
      );
      if (ok) {
        promptAction.showToast({ message: '保存成功' });
        router.back();
      } else {
        // 数据库保存失败，尝试本地保存
        const localOk = AppService.updateCurrentUser(this.nickname.trim(), this.avatarUri);
        if (localOk) {
          promptAction.showToast({ message: '已本地保存（后端未连接）' });
          router.back();
        } else {
          promptAction.showToast({ message: '保存失败，请重试' });
        }
      }
    } finally {
      this.isSaving = false;
    }
  }

  private hasChanges(): boolean {
    return this.nickname.trim() !== this.initialNickname ||
      this.phone.trim() !== this.initialPhone ||
      this.avatarUri.length > 0;
  }

  @Builder
  Label(text: string) {
    Text(text)
      .fontSize(12)
      .fontColor(AndroidColor.GREEN_HINT)
      .width('100%')
  }

  build() {
    Stack() {
      Circle()
        .width(260)
        .height(260)
        .fill(AndroidColor.GREEN_SOFT)
        .opacity(0.15)
        .position({ x: -80, y: -60 })
      Circle()
        .width(140)
        .height(140)
        .fill(AndroidColor.GREEN_SOFT)
        .opacity(0.08)
        .position({ x: 260, y: 300 })

      Column() {
        Row() {
          Text('<')
            .width(42)
            .height(42)
            .fontSize(24)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .backgroundColor('#6F9F62')
            .borderRadius(21)
            .onClick(() => router.back())
          Text('编辑个人信息')
            .layoutWeight(1)
            .fontSize(21)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
          Text(this.isSaving ? '...' : '保存')
            .width(42)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .onClick(() => this.save())
        }
        .width('100%')
        .height(62)
        .padding({ left: 14, right: 14 })
        .backgroundColor(AndroidColor.GREEN_HEADER)
        .borderRadius(14)
        .shadow({ radius: 5, color: '#22000000', offsetX: 0, offsetY: 2 })
        .margin({ bottom: 20 })

        Scroll() {
          Column() {
            // 头像可点击修改
            Stack() {
              if (this.avatarUri.length > 0) {
                Image(this.avatarUri)
                  .width(130)
                  .height(130)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(65)
                  .padding(4)
                  .backgroundColor(AndroidColor.GREEN_SOFT)
              } else {
                Image($r('app.media.image_1'))
                  .width(130)
                  .height(130)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(65)
                  .padding(4)
                  .backgroundColor(AndroidColor.GREEN_SOFT)
              }
              Text('修改头像')
                .fontSize(11)
                .fontColor(Color.White)
                .backgroundColor(AndroidColor.GREEN_PRIMARY)
                .padding({ left: 12, right: 12, top: 4, bottom: 4 })
                .borderRadius(8)
                .position({ x: 32, y: 118 })
                .onClick(() => this.pickAvatar())
            }
            .width(130)
            .height(150)
            .margin({ top: 10, bottom: 24 })

            Column() {
              this.Label('昵称')
              TextInput({ placeholder: '请输入昵称', text: this.nickname })
                .width('100%')
                .height(50)
                .fontSize(15)
                .fontColor(AndroidColor.GREEN_LABEL)
                .placeholderColor('#BDD1B8')
                .padding({ left: 16, right: 16 })
                .backgroundColor('#F8FCF7')
                .margin({ top: 6 })
                .onChange((value: string) => this.nickname = value)

              Blank().height(16)
              this.Label('手机号')
              TextInput({ placeholder: '请输入手机号', text: this.phone })
                .width('100%')
                .height(50)
                .fontSize(15)
                .fontColor(AndroidColor.GREEN_LABEL)
                .placeholderColor('#BDD1B8')
                .padding({ left: 16, right: 16 })
                .backgroundColor('#F8FCF7')
                .margin({ top: 6 })
                .type(InputType.PhoneNumber)
                .maxLength(11)
                .onChange((value: string) => this.phone = value)

              Text('修改手机号后下次登录请使用新手机号')
                .fontSize(11)
                .fontColor('#9EBA95')
                .margin({ top: 8, left: 4 })
                .width('100%')
            }
            .width('100%')
            .padding(24)
            .backgroundColor(Color.White)
            .borderRadius(14)
            .shadow({ radius: 4, color: '#22000000', offsetX: 0, offsetY: 2 })
            .margin({ bottom: 40 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AndroidColor.PAGE_BG)
  }
}
