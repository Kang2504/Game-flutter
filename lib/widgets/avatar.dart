import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final int clearedCase;
  final double size;
  const Avatar({
    super.key,
    required this.avatarUrl,
    required this.clearedCase,
    this.size = 80,
  });

  String get _frameAsset {
    if (clearedCase >= 50) return 'assets/frames/gold.jpg';
    if (clearedCase >= 10) return 'assets/frames/silver.jpg';
    if (clearedCase >= 3) return 'assets/frames/Cu.jpg';
    return 'assets/frames/wood.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(_frameAsset),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Container(
          width: size * 0.78,
          height: size * 0.78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(avatarUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: Colors.brown.shade900,
              width: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
