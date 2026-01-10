import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/widgets/card_suspects.dart';
import 'package:glogic/widgets/card_weapons_rooms.dart';
import 'package:glogic/widgets/matrix.dart';
import 'package:glogic/widgets/text_trusts.dart';

class CaseDetailsScreen extends ConsumerWidget {
  const CaseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameCase currentCase =
        ModalRoute.of(context)!.settings.arguments as GameCase;
    final progressAsync = ref.watch(caseProgressProvider(currentCase.id));

    return Scaffold(
      backgroundColor: const Color(0xFFF5EBE0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.brown),
        title: Text(
          currentCase.title,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: progressAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.brown)),
        error: (err, stack) => Center(child: Text("Không thể tải hồ sơ: $err")),
        data: (savedProgress) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentCase.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C1B10),
                    height: 1.5,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(thickness: 2, color: Colors.brown),
                _buildLabel("DANH SÁCH NGHI PHẠM"),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentCase.suspects.length,
                  itemBuilder: (context, index) {
                    final s = currentCase.suspects[index];
                    return DetectiveProfileItem(
                      imageUrl: s.imageUrl ?? "",
                      name: s.name,
                      description: s.description,
                      personality: s.personality,
                    );
                  },
                ),
                _buildLabel("ĐỊA ĐIỂM", topPadding: 24),
                _buildHorizontalList(
                  itemCount: currentCase.rooms.length,
                  builder: (context, index) {
                    final room = currentCase.rooms[index];
                    return VerticalInfoCard(
                      imageUrl: room.imageUrl ?? "",
                      name: room.name,
                      description: room.description,
                      inout: room.inout,
                      color: Colors.green,
                    );
                  },
                ),
                _buildLabel("HUNG KHÍ", topPadding: 24),
                _buildHorizontalList(
                  itemCount: currentCase.weapons.length,
                  height: 270,
                  builder: (context, index) {
                    final weapon = currentCase.weapons[index];
                    return VerticalInfoCard(
                      imageUrl: weapon.imageUrl ?? "",
                      name: weapon.name,
                      description: weapon.description,
                      inout: weapon.material,
                      color: const Color.fromARGB(255, 175, 132, 0),
                    );
                  },
                ),

                const SizedBox(height: 12),
                _buildLabel("SỰ THẬT ĐỎ"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TruthList(
                    items: currentCase.clues,
                    color: Colors.red.shade900,
                  ),
                ),

                _buildLabel("SỰ THẬT XANH"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TruthList(
                    items: currentCase.testimony,
                    color: Colors.blue.shade900,
                  ),
                ),

                const SizedBox(height: 30),
                const Divider(thickness: 2, color: Colors.brown),
                _buildLabel("MA TRẬN LOẠI TRỪ", verticalPadding: 16),
                MatrixSelectPage(
                  gamecase: currentCase,
                  initialState: savedProgress,
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  // Hàm tạo tiêu đề Section
  Widget _buildLabel(
    String text, {
    double topPadding = 12,
    double verticalPadding = 12,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: topPadding,
        bottom: verticalPadding,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.brown,
        ),
      ),
    );
  }

  // Hàm tạo danh sách cuộn ngang
  Widget _buildHorizontalList({
    required int itemCount,
    required IndexedWidgetBuilder builder,
    double height = 320,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: builder,
      ),
    );
  }
}
