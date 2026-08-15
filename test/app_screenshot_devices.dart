import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:golden_screenshot/golden_screenshot.dart';

enum AppScreenshotDevices {
  android(
    ScreenshotDevice(
      platform: TargetPlatform.android,
      resolution: Size(1080, 2400),
      pixelRatio: 3,
      goldenSubFolder: 'android/',
      frameBuilder: ScreenshotFrame.androidPhone,
    ),
  ),

  iphone(
    ScreenshotDevice(
      platform: TargetPlatform.iOS,
      resolution: Size(1290, 2796),
      pixelRatio: 3,
      goldenSubFolder: 'iphone/',
      frameBuilder: ScreenshotFrame.iphone,
    ),
  );

  const AppScreenshotDevices(this.device);

  final ScreenshotDevice device;
}
