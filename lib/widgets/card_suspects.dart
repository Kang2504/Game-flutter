import 'package:flutter/material.dart';
import 'package:float_column/float_column.dart';

class DetectiveProfileItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String personality;

  const DetectiveProfileItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.personality,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FloatColumn(
            children: [
              Floatable(
                float: FCFloat.start,
                padding: const EdgeInsets.only(right: 12, bottom: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              WrappableText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${name.toUpperCase()}\n',
                      style: const TextStyle(
                        color: Color(0xFFD32F2F),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            personality,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
