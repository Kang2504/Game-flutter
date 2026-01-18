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
      backgroundColor: const Color(0xFFF5EBE0),
      appBar: AppBar(
        title: const Text('Hồ sơ thám tử'),
        backgroundColor: const Color(0xFFD5C5B5),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (profile) => ProfileBody(profile: profile),
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  final ProfileModel profile;
  const ProfileBody({super.key, required this.profile});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(child: ProfileHeader(profile: widget.profile)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProfileForm(profile: widget.profile),
          ),
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
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 10),
        DetectiveNameBadge(
          name: (profile.name?.trim().isNotEmpty ?? false)
              ? profile.name!
              : 'Ẩn danh',
          clearedCase: profile.lastClearedCase,
        ),
      ],
    );
  }
}

class ProfileForm extends ConsumerStatefulWidget {
  final ProfileModel profile;
  const ProfileForm({super.key, required this.profile});

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  late final int clearCaseId;
  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.profile.name ?? '';
    clearCaseId = widget.profile.lastClearedCase;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    ref.read(profileProvider.notifier).changeName(name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.profile.id != widget.profile.id) {
      _nameCtrl.text = widget.profile.name ?? 'Ẩn danh';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameCtrl,
            maxLength: 18,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Tôi có thể gọi bằng?';
              }
              if (v.trim().length > 18) {
                return 'Tên không được quá 18 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(
              labelText: "Số vụ án đã phá",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              clearCaseId.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(onPressed: _submit, child: const Text('Lưu')),
          ),
        ],
      ),
    );
  }
}
