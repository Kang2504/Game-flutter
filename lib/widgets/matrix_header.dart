import 'package:flutter/material.dart';

class MatrixTopHeader extends StatelessWidget {
  final List<String> images;

  const MatrixTopHeader({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: images
          .map(
            (url) => Container(
              width: 45,
              height: 50,
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(url, fit: BoxFit.cover),
              ),
            ),
          )
          .toList(),
    );
  }
}
class MatrixSideHeader extends StatelessWidget { // Tiêu đề ảnh bên trái
  final List<String> images;

  const MatrixSideHeader({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: images
          .map(
            (url) => Container(
              width: 50,
              height: 45,
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(url, fit: BoxFit.cover),
              ),
            ),
          )
          .toList(),
    );
  }
}