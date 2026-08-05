import 'package:flutter/animation.dart';

/// Central animation timings so transitions remain consistent and restrained.
abstract final class AppMotion {
  static const short = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 280);
  static const curve = Curves.easeOutCubic;
}
