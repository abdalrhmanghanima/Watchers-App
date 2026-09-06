import 'package:flutter/material.dart';

enum DeviceTier { small, normal, large }

abstract final class DeviceBreakpoints {
  static const double designWidth = 390;
  static const double designHeight = 844;
  static const double smallMaxWidth = 359;
  static const double largeMinWidth = 412;

  static DeviceTier tierOfWidth(double width) {
    if (width < smallMaxWidth) return DeviceTier.small;
    if (width >= largeMinWidth) return DeviceTier.large;
    return DeviceTier.normal;
  }

  static DeviceTier of(BuildContext context) =>
      tierOfWidth(MediaQuery.sizeOf(context).width);
}
