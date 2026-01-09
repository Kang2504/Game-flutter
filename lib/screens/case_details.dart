import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/widgets/card_suspects.dart';
import 'package:glogic/widgets/card_weapons_rooms.dart';
import 'package:glogic/widgets/text_trusts.dart';

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

  @override
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
    final gameStatus = ref.watch(gameLogicProvider);

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
            //fontFamily: 'Courier',
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Text(
                "DANH SÁCH NGHI PHẠM",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.brown,
                ),
              ),
            ),

            ListView.builder(
              padding:
                  EdgeInsets.zero, // Xóa bỏ khoảng trống thừa của danh sách
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
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
              child: Text(
                "ĐỊA ĐIỂM",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.brown,
                ),
              ),
            ),

            SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: currentCase.rooms.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
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
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "HUNG KHÍ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.brown,
                ),
              ),
            ),

            SizedBox(
              height: 270,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: currentCase.weapons.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
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
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              child: Text(
                "SỰ THẬT ĐỎ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.brown,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TruthList(
                items: currentCase.clues,
                color: const Color.fromARGB(255, 255, 0, 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0,),
              child: Text(
                "SỰ THẬT XANH",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.brown,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TruthList(
                items: currentCase.testimony,
                color: const Color.fromARGB(255, 13, 0, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
