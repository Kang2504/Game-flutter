import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
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

final gameCasesProvider = FutureProvider<List<GameCase>>((ref) async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('cases')
      .select()
      .order('id', ascending: true);

  final data = response as List<dynamic>;
  return data.map((e) => GameCase.fromJson(e)).toList();
});

final userProfileProvider = FutureProvider<int>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) return 0;

  try {
    final data = await supabase
        .from('profiles')
        .select('last_cleared_case')
        .eq('id', user.id)
        .maybeSingle();
    if (data == null) return 0;
    return (data['last_cleared_case'] as int?) ?? 0;
  } catch (e) {
    //print("Lỗi Service Profile: $e");
    return 0;
  }
});

class GameService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> updateLastClearedCase(int newCaseId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    await _supabase.from('profiles').update({
      'last_cleared_case': newCaseId,
    }).eq('id', user.id);
  }
}

// Tạo provider cho service này để sử dụng ở các màn hình chơi game
final gameServiceProvider = Provider((ref) => GameService());