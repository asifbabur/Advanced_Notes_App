import 'package:flutter/material.dart';
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: size ?? Size(250, 45),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: buttonColor ?? Colors.blue, // Background color
        foregroundColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
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
