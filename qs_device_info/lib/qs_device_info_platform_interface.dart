import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qs_device_info_method_channel.dart';

abstract class QsDeviceInfoPlatform extends PlatformInterface {
  /// Constructs a QsDeviceInfoPlatform.
  QsDeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static QsDeviceInfoPlatform _instance = MethodChannelQsDeviceInfo();

  /// The default instance of [QsDeviceInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelQsDeviceInfo].
  static QsDeviceInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QsDeviceInfoPlatform] when
  /// they register themselves.
  static set instance(QsDeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
