import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hình ảnh bên trái
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      Container(color: Colors.grey[300], child: const Icon(Icons.person)),
                ),
              ),
              const SizedBox(width: 12),
              
              // 2. Column chứa Name và Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFD32F2F), // Màu đỏ hung thủ
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // 3. Personality nằm dưới cùng của Column chính
          // (Nó sẽ tự động chiếm toàn bộ chiều ngang bên dưới cả ảnh và text)
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF5E6), // Màu giấy hơi vàng nhẹ
              borderRadius: BorderRadius.circular(6),
              border: Border(left: BorderSide(color: Colors.brown.shade300, width: 4)),
            ),
            child: Text(
              personality,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}