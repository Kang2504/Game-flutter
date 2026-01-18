import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/auth_provider.dart';
import 'package:glogic/models/game.dart';
import 'package:glogic/widgets/avatar.dart';
import 'package:glogic/widgets/detective_name.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ thám tử')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (profile) => ProfileBody(profile: profile),
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final ProfileModel profile;

  const ProfileBody({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(profile: profile),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Đổi mật khẩu'),
          onTap: () {}, // làm sau
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Đăng xuất'),
          onTap: () {}, // làm sau
        ),
      ],
    );
  }
}

class ProfileHeader extends ConsumerWidget {
  final ProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final isLoading = profileAsync.isLoading;

    return Column(
      children: [
        GestureDetector(
          onTap: isLoading
              ? null
              : () => ref.read(profileProvider.notifier).changeAvatar(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Avatar(
                avatarUrl:
                    profile.avatar ??
                    'https://images.stockcake.com/public/a/c/f/acfb40f8-55fe-4019-8c7e-ccdd2e3b11b4_large/detective-analyzing-clues-stockcake.jpg',
                clearedCase: profile.lastClearedCase,
                size: 170,
              ),
              if (isLoading)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => _editName(context, ref, profile),
          child: DetectiveNameBadge(
            name: profile.name ?? 'Người chơi',
            clearedCase: profile.lastClearedCase,
          ),
        ),
      ],
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    ProfileModel profile,
  ) async {
    final ctrl = TextEditingController(text: profile.name ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đổi tên'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await ref.read(profileProvider.notifier).changeName(result);
    }
  }
}
