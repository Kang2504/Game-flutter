import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/models/game.dart';

class CaseSelectionScreen extends ConsumerWidget {
  const CaseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(gameCasesProvider);
    final lastClearedAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'HỒ SƠ VỤ ÁN',
          style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD5C5B5),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5EBE0),
      body: casesAsync.when(
        data: (allCases) => lastClearedAsync.when(
          data: (lastClearedId) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allCases.length,
              itemBuilder: (context, index) {
                final currentCase = allCases[index];
                bool isDone = currentCase.id <= lastClearedId;
                bool isLocked = currentCase.id > (lastClearedId + 1);

                return _buildCaseTile(
                  gameCase: currentCase,
                  isLocked: isLocked,
                  isDone: isDone,
                  onTap: () {
                    if (isLocked) {
                    } else {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: currentCase,
                      );
                    }
                  },
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.brown),
          ),
          error: (e, s) => Center(child: Text('Lỗi kết nối hồ sơ: $e')),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.brown)),
        error: (e, s) => Center(child: Text('Lỗi tải danh sách vụ án: $e')),
      ),
    );
  }

  Widget _buildCaseTile({
    required GameCase gameCase,
    required bool isLocked,
    required bool isDone,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Opacity(
        opacity: isLocked ? 0.4 : 1.0,
        child: Card(
          elevation: isLocked ? 0 : 4,
          color: isDone ? const Color(0xFFD8E2DC) : const Color(0xFFE3D5CA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isLocked ? Colors.grey : Colors.brown,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: CircleAvatar(
              backgroundColor: isLocked
                  ? Colors.grey
                  : (isDone ? Colors.green : Colors.brown),
              child: Icon(
                isLocked
                    ? Icons.lock_outline
                    : (isDone ? Icons.check_circle : Icons.search),
                color: Colors.white,
              ),
            ),
            title: Text(
              "VỤ ÁN #${gameCase.id}",
              style: const TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                color: Colors.black54,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameCase.title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isLocked ? Colors.black38 : Colors.black87,
                  ),
                ),
                if (!isLocked)
                  Text(
                    gameCase.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
            trailing: isLocked
                ? null
                : const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }
}
