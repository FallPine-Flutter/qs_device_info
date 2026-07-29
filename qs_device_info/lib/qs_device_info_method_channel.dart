import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qs_device_info_platform_interface.dart';

/// An implementation of [QsDeviceInfoPlatform] that uses method channels.
class MethodChannelQsDeviceInfo extends QsDeviceInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qs_device_info');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
