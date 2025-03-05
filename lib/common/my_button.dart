import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_notes_flutter/common/my_text.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Size? size;
  final FontWeight? textWeight;
  final double? fontSize;
  final Color? buttonColor;
  final Widget? icon;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize,
    this.textWeight,
    this.buttonColor,
    this.size,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          fixedSize: size ?? const Size(250, 45),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          backgroundColor: buttonColor ?? Colors.blue, // Button background color
          foregroundColor: Colors.white, // Text color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      cupertino: (_, __) => CupertinoElevatedButtonData(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        color: buttonColor ?? CupertinoColors.activeBlue,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          MyText(
            text,
            color: Colors.white,
            fontWeight: textWeight ?? FontWeight.bold,
            fontSize: fontSize ?? 12,
          ),
        ],
      ),
    );
  }
}
