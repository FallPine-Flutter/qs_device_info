# qs_device_info

`qs_device_info` 是一个 Flutter 设备与应用信息工具库，用于统一获取设备标识、设备型号、系统版本、应用版本、应用名称、应用 ID、屏幕尺寸以及当前运行平台。

## 支持平台

- Android
- iOS

## 安装

在项目的 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  qs_device_info: ^1.0.0
```

如果使用本地路径依赖：

```yaml
dependencies:
  qs_device_info:
    path: ../qs_device_info
```

然后执行：

```shell
flutter pub get
```

## 引入

```dart
import 'package:qs_device_info/qs_device_info.dart';
```

## 快速使用

```dart
Future<void> loadDeviceInfo() async {
  final userId = await QsDeviceInfo.getUserId();
  final isPad = await QsDeviceInfo.isPad();
  final appVersion = await QsDeviceInfo.getAppVersion();
  final deviceModel = await QsDeviceInfo.getDeviceModel();
  final osVersion = await QsDeviceInfo.getDeviceOSVersion();
  final deviceType = QsDeviceInfo.getDeviceType();
  final screenInfo = QsDeviceInfo.getScreenInfo();
  final appId = await QsDeviceInfo.getAppId(iOSAppId: 'your-ios-app-id');
  final appName = await QsDeviceInfo.getAppName();

  print('userId: $userId');
  print('isPad: $isPad');
  print('appVersion: $appVersion');
  print('deviceModel: $deviceModel');
  print('osVersion: $osVersion');
  print('deviceType: $deviceType');
  print('screenInfo: $screenInfo');
  print('appId: $appId');
  print('appName: $appName');
}
```

## API 说明

### getUserId

获取当前设备的用户标识。

```dart
final userId = await QsDeviceInfo.getUserId();
```

说明：

- iOS 优先使用 `identifierForVendor`。
- Android 优先使用系统返回的设备 ID。
- 如果无法获取设备 ID，会生成一个 UUID。
- 获取到的值会通过安全存储缓存，后续调用会优先返回缓存值。

### isPad

判断当前设备是否为平板设备。

```dart
final isPad = await QsDeviceInfo.isPad();
```

说明：

- iOS 会根据设备 `modelName` 判断是否包含 `pad`。
- Android 会根据设备 `model` 判断是否包含 `pad`。
- 获取失败时返回 `false`。

### getAppVersion

获取应用版本号。

```dart
final version = await QsDeviceInfo.getAppVersion();
```

返回值示例：

```text
1.0.0
```

### getDeviceModel

获取设备型号。

```dart
final model = await QsDeviceInfo.getDeviceModel();
```

说明：

- iOS 返回设备 machine 标识，例如 `iPhone16,2`。
- Android 返回设备 model。
- 获取失败时返回 `unknown`。

### getDeviceOSVersion

获取设备系统版本。

```dart
final osVersion = await QsDeviceInfo.getDeviceOSVersion();
```

返回值示例：

```text
iOS 17.0
```

```text
samsung 14
```

### getDeviceType

获取当前运行平台类型。

```dart
final type = QsDeviceInfo.getDeviceType();
```

可能返回：

- `web`
- `ios`
- `android`
- `macos`
- `windows`
- `linux`
- `unknown`

### getScreenInfo

获取当前屏幕逻辑尺寸。

```dart
final screenInfo = QsDeviceInfo.getScreenInfo();
```

返回格式：

```text
宽度x高度
```

示例：

```text
390x844
```

### getAppId

获取应用 ID。

```dart
final appId = await QsDeviceInfo.getAppId(iOSAppId: 'your-ios-app-id');
```

说明：

- Android 返回应用包名。
- iOS 无法通过通用接口直接获取 App Store 应用 ID，需要通过 `iOSAppId` 参数传入。

### getAppName

获取应用名称。

```dart
final appName = await QsDeviceInfo.getAppName();
```

### getPlatformVersion

获取原生平台版本。

```dart
final plugin = QsDeviceInfo();
final platformVersion = await plugin.getPlatformVersion();
```

返回值示例：

```text
Android 14
```

```text
iOS 17.0
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:qs_device_info/qs_device_info.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  String _content = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final userId = await QsDeviceInfo.getUserId();
    final appName = await QsDeviceInfo.getAppName();
    final appVersion = await QsDeviceInfo.getAppVersion();
    final deviceModel = await QsDeviceInfo.getDeviceModel();
    final osVersion = await QsDeviceInfo.getDeviceOSVersion();
    final screenInfo = QsDeviceInfo.getScreenInfo();

    if (!mounted) {
      return;
    }

    setState(() {
      _content = '''
userId: $userId
appName: $appName
appVersion: $appVersion
deviceModel: $deviceModel
osVersion: $osVersion
screenInfo: $screenInfo
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(_content),
      ),
    );
  }
}
```

## 注意事项

- `getUserId` 会将设备标识缓存到安全存储中，适合用于业务侧稳定识别当前安装环境。
- `getAppId` 在 iOS 上需要手动传入 App Store 应用 ID。
- `getScreenInfo` 返回的是逻辑尺寸，不是物理像素尺寸。
- 当前插件主要面向 Android 与 iOS 使用。
