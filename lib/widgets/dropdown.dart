import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/auth_provider.dart';

class DetectiveMenu extends ConsumerWidget {
  const DetectiveMenu({super.key});

  static const Color _paperColor = Color(0xFFE3D5CA);
  static const Color _inkColor = Color(0xFF2B2B2B);
  static const Color _bloodRed = Color(0xFF8B0000);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      surfaceTintColor: _paperColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _inkColor, width: 1.5),
      ),
      child: authState.isLoading 
        ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2))
        : _buildMenuTrigger(),
      onSelected: (value) async {
        if (value == 'logout') {
          await ref.read(authProvider.notifier).signOut();
          
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
          }
        } else if (value == 'profile') {
          // Xử lý hồ sơ thám tử
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(
          value: 'profile',
          icon: Icons.assignment_ind_rounded,
          text: 'HỒ SƠ THÁM TỬ',
          color: _inkColor,
        ),
        const PopupMenuDivider(height: 1),
        _buildMenuItem(
          value: 'logout',
          icon: Icons.exit_to_app_rounded,
          text: 'RÚT KHỎI VỤ ÁN',
          color: _bloodRed,
        ),
      ],
    );
  }

  // Các hàm build phụ giữ nguyên như cũ để đảm bảo code sạch
  Widget _buildMenuTrigger() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
        border: Border.all(color: _paperColor.withOpacity(0.5)),
      ),
      child: const Icon(Icons.person_search_rounded, color: _paperColor, size: 28),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontFamily: 'Courier')),
        ],
      ),
    );
  }
}

