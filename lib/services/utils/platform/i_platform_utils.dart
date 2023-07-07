import 'package:flutter/material.dart';

enum PlatformType {
  mobile,
  desktop,
  web,
}

abstract class IPlatformUtils {
  PlatformType getPlatformType();

  bool canDetectInstalledApps();

  bool isBottomSheet();

  bool isLongBottomSheet(Orientation orientation);

  bool isMobileWidth(double width);
}
