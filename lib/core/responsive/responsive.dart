import 'package:flutter/material.dart';

import 'responsive_breakpoints.dart';
import 'responsive_sizes.dart';

extension ResponsiveContext on BuildContext {
  DeviceTier get deviceTier => DeviceBreakpoints.of(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  ResponsiveSizes get sizes => ResponsiveSizes.of(this);

  double scaleByHeight(double value) =>
      value * (screenHeight / DeviceBreakpoints.designHeight).clamp(0.92, 1.08);
}
