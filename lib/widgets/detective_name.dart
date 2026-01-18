import 'package:flutter/material.dart';

class DetectiveNameBadge extends StatelessWidget {
  final String name;
  final int clearedCase;
  final double fontSize;

  const DetectiveNameBadge({
    super.key,
    required this.name,
    required this.clearedCase,
    this.fontSize = 24,
  });

  String get _title {
    if (clearedCase >= 50) return 'Đại Thám Tử';
    if (clearedCase >= 10) return 'Thanh Tra';
    if (clearedCase >= 3) return 'Điều Tra Viên';
    return 'Tập Sự';
  }

  Color get _color {
    if (clearedCase >= 50) return const Color(0xFFD4AF37);
    if (clearedCase >= 10) return Colors.grey.shade400;
    if (clearedCase >= 3) return const Color(0xFFB87333);
    return Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$_title ',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: _color,
              letterSpacing: 1.2,
            ),
          ),
          TextSpan(
            text: name,
            style: TextStyle(
              fontSize: fontSize - 1,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
