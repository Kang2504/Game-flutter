import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/widgets/card_suspects.dart';

class CaseDetailsScreen extends ConsumerStatefulWidget {
  const CaseDetailsScreen({super.key});

  @override
  ConsumerState<CaseDetailsScreen> createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends ConsumerState<CaseDetailsScreen> {
  Map<String, dynamic> localMatrixState = {};
  int? selectedSuspectId;
  int? selectedWeaponId;
  int? selectedRoomId;
  bool isCollapsed = false;
  bool isInitialized = false;
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      _initializeData();
      isInitialized = true;
    }
  }

  Future<void> _initializeData() async {
    final GameCase currentCase =
        ModalRoute.of(context)!.settings.arguments as GameCase;

    // Gọi provider để lấy matrix_state đã lưu từ trước (nếu có)
    final savedProgress = await ref.read(
      caseProgressProvider(currentCase.id).future,
    ); //.future là lấy trực tiếp data, .notifier là lấy class của nó

    setState(() {
      localMatrixState = Map<String, dynamic>.from(savedProgress);
    });
  }

  @override
  Widget build(BuildContext context) {
    final GameCase currentCase =
        ModalRoute.of(context)!.settings.arguments as GameCase;
    // Theo dõi trạng thái của các lệnh Save/Solve (để hiện loading)
    final gameStatus = ref.watch(gameLogicProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EBE0),
      appBar: AppBar(
        // AppBar trong suốt để hòa làm một với background
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.brown),
        title: Text(
          currentCase.title, // Tên vụ án nằm trên AppBar
          style: const TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier', // Kiểu chữ máy đánh chữ
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Đoạn văn bản mô tả vụ án - Chữ to và trang trọng
            Text(
              currentCase.description,
              style: const TextStyle(
                fontSize: 16, // Chữ to như thám tử yêu cầu
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C1B10), // Màu nâu đen đậm
                height: 1.5, // Khoảng cách dòng rộng cho dễ đọc
                fontFamily: 'Georgia', // Kiểu chữ có chân cổ điển
              ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 2, color: Colors.brown),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                "DANH SÁCH NGHI PHẠM",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.brown,
                ),
              ),
            ),

            // 3. Hiển thị danh sách Nghi phạm bằng Widget thám tử đã code
            ListView.builder(
              shrinkWrap: true, // Quan trọng: Để ListView nằm trong Column
              physics: const NeverScrollableScrollPhysics(), // Để dùng chung scroll với SingleChildScrollView
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

            // Các phần tiếp theo sẽ code tại đây khi thám tử ra lệnh
          ],
        ),
      ),
    );
  }
}
