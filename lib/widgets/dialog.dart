import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/models/game.dart';

/// SHOW DIALOG
void showConclusionDialog({
  required BuildContext context,
  required GameCase gameCase,
  required Map<String, dynamic> finalMatrix,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Kết luận',
    barrierColor: Colors.black.withOpacity(0.7),
    pageBuilder: (_, __, ___) {
      return Center(
        child: ConclusionPopup(data: gameCase, finalMatrix: finalMatrix),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(opacity: anim, child: child);
    },
  );
}

//POPUP CHỌN + KẾT LUẬN
class ConclusionPopup extends ConsumerStatefulWidget {
  final GameCase data;
  final Map<String, dynamic> finalMatrix;

  const ConclusionPopup({
    super.key,
    required this.data,
    required this.finalMatrix,
  });

  @override
  ConsumerState<ConclusionPopup> createState() => _ConclusionPopupState();
}

class _ConclusionPopupState extends ConsumerState<ConclusionPopup> {
  int? suspectId;
  int? weaponId;
  int? roomId;

  Future<void> conclude() async {
    final isCorrect = await ref
        .read(gameLogicProvider.notifier)
        .solveCase(
          gameCase: widget.data,
          sId: suspectId!,
          wId: weaponId!,
          rId: roomId!,
          finalMatrix: widget.finalMatrix,
        );

    if (!mounted) return;
    if (isCorrect) {
      ref.read(gameServiceProvider).updateLastClearedCase(widget.data.id);
      ref.invalidate(userProfileProvider);
    }
    Navigator.pop(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: !isCorrect,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierLabel: 'Kết quả suy luận',
      pageBuilder: (_, __, ___) =>
          Center(child: ConclusionResultPopup(isCorrect: isCorrect)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(gameLogicProvider).isLoading;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SimpleSelect<Suspect>( //<T> kiểu data tổng quát
              title: 'Hung thủ',
              items: widget.data.suspects,
              getId: (s) => s.id, //Nhận s, trả về s.id
              getLabel: (s) => s.name,
              onSelected: (id) => setState(() => suspectId = id), //truyền hàm (id) Setstate vào...
            ),

            SimpleSelect<Weapon>(
              title: 'Hung khí',
              items: widget.data.weapons,
              getId: (w) => w.id,
              getLabel: (w) => w.name,
              onSelected: (id) => setState(() => weaponId = id),
            ),

            SimpleSelect<Room>(
              title: 'Địa điểm',
              items: widget.data.rooms,
              getId: (r) => r.id,
              getLabel: (r) => r.name,
              onSelected: (id) => setState(() => roomId = id),
            ),

            const SizedBox(height: 16),

            ///NÚT KẾT LUẬN
            GestureDetector(
              onTap:
                  (suspectId != null &&
                      weaponId != null &&
                      roomId != null &&
                      !isLoading)
                  ? conclude
                  : null,
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors:
                        (suspectId != null &&
                            weaponId != null &&
                            roomId != null)
                        ? [Colors.orange, Colors.deepOrange]
                        : [Colors.grey, Colors.grey],
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'KẾT LUẬN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleSelect<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final int Function(T) getId; //đưa hàm getId vào trả về int
  final String Function(T) getLabel;
  final ValueChanged<int> onSelected; //callback trả về void

  const SimpleSelect({
    super.key,
    required this.title,
    required this.items,
    required this.getId,
    required this.getLabel,
    required this.onSelected,
  });

  @override
  State<SimpleSelect<T>> createState() => _SimpleSelectState<T>();
}

class _SimpleSelectState<T> extends State<SimpleSelect<T>> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    final double maxWidth = 300;
    final int columns = 3;
    final double spacing = 8;
    final double chipWidth = (maxWidth - (columns - 1) * spacing) / columns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: spacing,
          runSpacing: 8,
          children: widget.items.map((item) {
            final id = widget.getId(item);
            final selected = id == selectedId;
            final label = widget.getLabel(item); //Chạy hàm

            return InkWell(
              onTap: () {
                setState(() => selectedId = id);
                widget.onSelected(id);
              },
              child: Container(
                width: chipWidth,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: selected ? Colors.blue.shade200 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selected ? Colors.blue : Colors.grey.shade400),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}



/// =======================
/// POPUP KẾT QUẢ (ĐẸP)
/// =======================
class ConclusionResultPopup extends StatefulWidget {
  final bool isCorrect;
  const ConclusionResultPopup({super.key, required this.isCorrect});

  @override
  State<ConclusionResultPopup> createState() => _ConclusionResultPopupState();
}

class _ConclusionResultPopupState extends State<ConclusionResultPopup> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));

    if (widget.isCorrect) {
      _confetti.play();
      Timer(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isCorrect ? Colors.green : Colors.red;
    final icon = widget.isCorrect ? Icons.check_circle : Icons.cancel;
    final text = widget.isCorrect
        ? 'Thám tử đã suy luận đúng'
        : 'Thám tử đã suy luận sai.';

    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 80, color: color),
                const SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isCorrect)
            ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.08,
              numberOfParticles: 25,
              gravity: 0.3,
            ),
        ],
      ),
    );
  }
}
