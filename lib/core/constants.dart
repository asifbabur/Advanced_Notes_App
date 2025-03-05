import 'package:flutter/material.dart';

class AppColors {
  static const primaryBlueColor = Color.fromARGB(255, 14, 88, 148);
  static const primarybgColor = Colors.black54;
  static const greenButtonColor = Colors.lightGreen;
}

extension size on int {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
}
