import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/widgets/button_matrix.dart';
import 'package:glogic/widgets/matrix_header.dart';
import 'package:glogic/widgets/render_matrix.dart';
import 'package:glogic/widgets/save_button.dart';

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

  @override
  void didUpdateWidget(covariant MatrixSelectPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // nếu initialState mới khác cũ, reset cells
    if (oldWidget.initialState != widget.initialState) {
      setState(() {
        cells = Map<String, dynamic>.from(widget.initialState);
      });
    }
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

    return Stack(
      children: [
        Column(
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
                            keyBuilder:
                                _buildKey, // Truyền tham chiếu hàm buildKey
                            onCellTap:
                                onCellTap, // Truyền tham chiếu hàm onCellTap
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
          ],
        ),
        Positioned(
          top: 8,
          left: 25,
          child: SaveProgressButton(
            caseId: widget.gamecase.id,
            currentMatrix: cells,
          ),
        ),
      ],
    );
  }
}
