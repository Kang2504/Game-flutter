import 'package:flutter/material.dart';

class CaseSubGrid extends StatelessWidget { //Render ma trận dựa trên map
  final String rType;
  final String cType;
  final int rows;
  final int cols;
  final double size;
  final Map<String, dynamic> cells;
  final String Function(String rType, int rIdx, String cType, int cIdx) keyBuilder;
  final Function(String key) onCellTap;

  const CaseSubGrid({
    super.key,
    required this.rType,
    required this.cType,
    required this.rows,
    required this.cols,
    required this.size,
    required this.cells,
    required this.keyBuilder,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    //Tới đây
    return Container(
      width: size * cols,
      height: size * rows,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rows * cols,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
        ),
        itemBuilder: (context, index) {
          int r = index ~/ cols; //Vị trí hàng thứ r
          int c = index % cols; //Vị trí cột thứ c
          String key = keyBuilder(rType, r, cType, c);
          int? val = cells[key];

          return GestureDetector(
            onTap: () => onCellTap(key),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 0.5),
                color: val == 1
                    ? Colors.green.withOpacity(0.05)
                    : val == 0
                        ? Colors.red.withOpacity(0.05)
                        : Colors.white,
              ),
              child: Center(
                child: val == null
                    ? null
                    : Icon(
                        val == 1 ? Icons.check : Icons.close,
                        color: val == 1 ? Colors.green : Colors.red,
                        size: size * 0.6,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}