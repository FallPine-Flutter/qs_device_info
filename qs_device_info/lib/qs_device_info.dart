import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qs_log/qs_log.dart';
import 'package:qs_secure_storage/qs_secure_storage.dart';
import 'package:uuid/uuid.dart';

class QsDeviceInfo {
  /// 获取userId
  static Future<String> getUserId() async {
    const kDeviceIdKey = "_deviceIdKey";
    String? id = await QsSecureStorage.getString(key: kDeviceIdKey);
    if (id != null) {
      return id;
    }

    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor; // iOS的设备标识符
      }
    } catch (e) {
      QsLog.error("获取设备信息失败 + $e");
    }

    // 如果无法获取设备ID，则生成一个UUID
    deviceId ??= const Uuid().v4();
    await QsSecureStorage.setString(key: kDeviceIdKey, value: deviceId);
    return deviceId;
  }

  /// 是否是iPad
  static Future<bool> isPad() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.modelName.toLowerCase().contains("pad");
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.model.toLowerCase().contains("pad"); // Android的设备ID
      }
    } catch (e) {
      QsLog.error("获取设备信息失败 + $e");
      return false;
    }
    return false;
  }

  /// 获取版本号
  static Future<String?> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// 获取设备型号
  static Future<String> getDeviceModel() async {
    final deviceInfo = DeviceInfoPlugin();
    String model = '';

    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        // 获取设备名称（如 iPhone16,2）
        model = iosInfo.utsname.machine;
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        model = androidInfo.model;
      }

      return model;
    } catch (e) {
      return 'unknown';
    }
  }

  /// 获取设备系统版本
  static Future<String> getDeviceOSVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    String name = '';

    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final String systemName = iosInfo.systemName;
        final String systemVersion = iosInfo.systemVersion;
        name = "$systemName $systemVersion";
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final String systemName = androidInfo.brand;
        final String systemVersion = androidInfo.version.release;
        name = "$systemName $systemVersion";
      }

      return name;
    } catch (e) {
      return 'unknown';
    }
  }

  /// 获取设备类型
  static String getDeviceType() {
    if (kIsWeb) {
      return "web";
    }
    if (Platform.isIOS) {
      return "ios";
    }
    if (Platform.isAndroid) {
      return "android";
    }
    if (Platform.isMacOS) {
      return "macos";
    }
    if (Platform.isWindows) {
      return "windows";
    }
    if (Platform.isLinux) {
      return "linux";
    }
    return "unknown";
  }

  /// 获取屏幕信息
  /// 格式：宽度x高度
  static String getScreenInfo() {
    final view =
        PlatformDispatcher.instance.implicitView ??
        PlatformDispatcher.instance.views.firstOrNull;
    if (view == null) {
      return "";
    }

    final width = view.physicalSize.width / view.devicePixelRatio;
    final height = view.physicalSize.height / view.devicePixelRatio;
    return "${width.round()}x${height.round()}";
  }

  /// 获取应用ID
  /// iOS应用ID无法直接获取，需要自己配置，这个方法只是为了统一使用接口调用
  static Future<String> getAppId({required String iOSAppId}) async {
    final appInfo = await PackageInfo.fromPlatform();
    if (!kIsWeb && Platform.isIOS) {
      return iOSAppId;
    }
    return appInfo.packageName;
  }

  /// 获取应用名称
  static Future<String> getAppName() async {
    final appInfo = await PackageInfo.fromPlatform();
    return appInfo.appName;
  }
}
