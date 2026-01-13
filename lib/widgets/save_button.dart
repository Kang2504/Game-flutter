import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/auth_provider.dart';

class SaveProgressButton extends ConsumerWidget {
  final int caseId;
  final Map<String, dynamic> currentMatrix;

  const SaveProgressButton({
    super.key,
    required this.caseId,
    required this.currentMatrix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await ref.read(gameLogicProvider.notifier).saveCurrentProgress(
              caseId: caseId,
              currentMatrix: currentMatrix,
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hồ sơ đã được lưu!")),
        );

        ref.invalidate(caseProgressProvider(caseId));
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.brown, width: 2),
          color: Colors.white, // nền trắng
        ),
        child: const Icon(
          Icons.save,
          color: Colors.brown,
          size: 20,
        ),
      ),
    );
  }
}
