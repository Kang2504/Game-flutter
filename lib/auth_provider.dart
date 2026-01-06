import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider =
    AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<void> {
  final _supabase = Supabase.instance.client;

  @override
  Future<void> build() async {}

  Future<void> signUp({
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _supabase.auth.signUp(
          phone: phone,
          password: password,
        ));
  }

  Future<void> signIn({
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _supabase.auth.signInWithPassword(
          phone: phone,
          password: password,
        ));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _supabase.auth.signOut());
  }
}
