import 'package:flutter_test/flutter_test.dart';
import 'package:qs_device_info/qs_device_info.dart';
import 'package:qs_device_info/qs_device_info_platform_interface.dart';
import 'package:qs_device_info/qs_device_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQsDeviceInfoPlatform
    with MockPlatformInterfaceMixin
    implements QsDeviceInfoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final QsDeviceInfoPlatform initialPlatform = QsDeviceInfoPlatform.instance;

  test('$MethodChannelQsDeviceInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQsDeviceInfo>());
  });

  test('getPlatformVersion', () async {
    QsDeviceInfo qsDeviceInfoPlugin = QsDeviceInfo();
    MockQsDeviceInfoPlatform fakePlatform = MockQsDeviceInfoPlatform();
    QsDeviceInfoPlatform.instance = fakePlatform;

    expect(await qsDeviceInfoPlugin.getPlatformVersion(), '42');
  });
}
