import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/widgets/button_matrix.dart';

class MatrixSelectPage extends ConsumerStatefulWidget {
  final GameCase gamecase;
  final Map<String, dynamic> initialState;

  const MatrixSelectPage({
    super.key,
    required this.gamecase,
    required this.initialState,
  });

  @override
  ConsumerState<MatrixSelectPage> createState() => _CaseMatrixState();
}

class _CaseMatrixState extends ConsumerState<MatrixSelectPage> {
  int selectedMode = 1; // 1 = tick, 0 = X
  late Map<String, dynamic> cells;

  @override
  void initState() {
    super.initState();
    cells = Map<String, dynamic>.from(widget.initialState);
  }

  // rowType_rowId_colType_colId
  String _buildKey(String rType, int rIdx, String cType, int cIdx) {
    final rId = _getId(rType, rIdx);
    final cId = _getId(cType, cIdx);
    return "${rType}_${rId}__${cType}_$cId";
  }

  String _getId(String type, int idx) {
    if (type == 's') return widget.gamecase.suspects[idx].id.toString();
    if (type == 'r') return widget.gamecase.rooms[idx].id.toString();
    if (type == 'w') return widget.gamecase.weapons[idx].id.toString();
    return "";
  }

  void onCellTap(String key) {
    setState(() {
      if (cells[key] == selectedMode) {
        cells[key] = null;
      } else {
        cells[key] = selectedMode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double cellSize = 45.0;
    const double headerSize = 50.0;

    return Column(
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: headerSize),
                  _buildSideHeader(
                    widget.gamecase.weapons
                        .map((e) => e.imageUrl ?? "")
                        .toList(),
                  ),
                  _buildSideHeader(
                    widget.gamecase.rooms.map((e) => e.imageUrl ?? "").toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      _buildTopHeader(
                        widget.gamecase.suspects
                            .map((e) => e.imageUrl ?? "")
                            .toList(),
                      ),
                      _buildTopHeader(
                        widget.gamecase.rooms
                            .map((e) => e.imageUrl ?? "")
                            .toList(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSubGrid('w', 's', 3, 3, cellSize),
                      _buildSubGrid('w', 'r', 3, 3, cellSize),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSubGrid('r', 's', 3, 3, cellSize),

                      Container(
                        width: cellSize * 3,
                        height: cellSize * 3,
                        alignment: Alignment.center,
                        child: ToggleCircleButton(
                          initialValue: selectedMode,
                          onChanged: (val) => setState(
                            () => selectedMode = val,
                          ), //Truyền hàm void (int val) {setState(() {selectedMode = val;});}
                          size: 65,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () async {
            await ref
                .read(gameLogicProvider.notifier)
                .saveCurrentProgress(
                  caseId: widget.gamecase.id,
                  currentMatrix: cells,
                );
            // Làm mới nó để lần tới quay lại nó sẽ tải data mới từ Server
            ref.invalidate(caseProgressProvider(widget.gamecase.id));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Hồ sơ đã được lưu!")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.cloud_upload),
          label: const Text(
            "LƯU TIẾN TRÌNH",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSubGrid( //Render ma trận dựa trên map
    //Tới đây
    String rType,
    String cType,
    int rows,
    int cols,
    double size,
  ) {
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
          String key = _buildKey(rType, r, cType, c);
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

  // Tiêu đề ảnh phía trên
  Widget _buildTopHeader(List<String> images) {
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

  // Tiêu đề ảnh bên trái
  Widget _buildSideHeader(List<String> images) {
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
