import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/widgets/button_matrix.dart';
import 'package:glogic/widgets/matrix_header.dart';
import 'package:glogic/widgets/render_matrix.dart';

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
                  MatrixSideHeader(
                    images: widget.gamecase.weapons
                        .map((e) => e.imageUrl ?? "")
                        .toList(),
                  ),
                  MatrixSideHeader(
                    images: widget.gamecase.rooms
                        .map((e) => e.imageUrl ?? "")
                        .toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      MatrixTopHeader(
                        images: widget.gamecase.suspects
                            .map((e) => e.imageUrl ?? "")
                            .toList(),
                      ),
                      MatrixTopHeader(
                        images: widget.gamecase.rooms
                            .map((e) => e.imageUrl ?? "")
                            .toList(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CaseSubGrid(
                        rType: 'w',
                        cType: 's',
                        rows: 3,
                        cols: 3,
                        size: cellSize,
                        cells: cells,
                        keyBuilder: _buildKey, // Truyền tham chiếu hàm buildKey
                        onCellTap: onCellTap, // Truyền tham chiếu hàm onCellTap
                      ),
                      CaseSubGrid(
                        rType: 'w',
                        cType: 'r',
                        rows: 3,
                        cols: 3,
                        size: cellSize,
                        cells: cells,
                        keyBuilder:
                            _buildKey, // Truyền tham chiếu hàm buildKey của thám tử
                        onCellTap:
                            onCellTap, // Truyền tham chiếu hàm onCellTap của thám tử
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CaseSubGrid(
                        rType: 'r',
                        cType: 's',
                        rows: 3,
                        cols: 3,
                        size: cellSize,
                        cells: cells,
                        keyBuilder:
                            _buildKey, // Truyền tham chiếu hàm buildKey của thám tử
                        onCellTap:
                            onCellTap, // Truyền tham chiếu hàm onCellTap của thám tử
                      ),

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
}
