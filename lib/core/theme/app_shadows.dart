import 'package:flutter/material.dart';

/// Elevation recipes kept deliberately subtle for a calm travel interface.
abstract final class AppShadows {
  static const card = [
    BoxShadow(
      color: Color(0x0F1D2D44),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: Color(0x1A1D2D44),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}
