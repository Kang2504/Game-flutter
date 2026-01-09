import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/models/game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<void> {
  final _supabase = Supabase.instance.client;

  @override
  Future<void> build() async {}

  Future<void> signUp({required String phone, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _supabase.auth.signUp(phone: phone, password: password),
    );
  }

  Future<void> signIn({required String phone, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _supabase.auth.signInWithPassword(phone: phone, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _supabase.auth.signOut());
  }
}

final gameCasesProvider = FutureProvider<List<GameCase>>((ref) async { //Lấy hết các cases, và cả các nội dung trong cases
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('cases')
      .select('''
        *,
        suspects!suspects_case_id_fkey (*),
        weapons!weapons_case_id_fkey (*),
        rooms!rooms_case_id_fkey (*)
      ''')
      .order('id', ascending: true);

  final data = response as List<dynamic>;
  return data.map((e) => GameCase.fromJson(e)).toList();
});

final userProfileProvider = FutureProvider<int>((ref) async { //Lấy màn chơi cuối cùng của người chơi
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
    return 0;
  }
});

class GameService { // cập nhật màn chơi mới nhất của người chơi
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> updateLastClearedCase(int newCaseId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    await _supabase
        .from('profiles')
        .update({'last_cleared_case': newCaseId})
        .eq('id', user.id);
  }
}

final gameServiceProvider = Provider((ref) => GameService());

final gameLogicProvider = AsyncNotifierProvider<GameLogicNotifier, void>(
  GameLogicNotifier.new,
);

class GameLogicNotifier extends AsyncNotifier<void> {
  final _supabase = Supabase.instance.client;

  @override
  Future<void> build() async {}

  //CHỨC NĂNG LƯU MA TRẬN (Chỉ gọi khi nhấn nút Save)
  Future<void> saveCurrentProgress({
    required int caseId,
    required Map<String, dynamic> currentMatrix,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('user_progress').upsert({
        'user_id': user.id,
        'case_id': caseId,
        'matrix_state': currentMatrix,
        // Lưu ý: không cập nhật is_completed ở đây vì họ chỉ đang lưu nháp
      }, onConflict: 'user_id,case_id');
    });
  }

  // 2. CHỨC NĂNG KẾT LUẬN (Vẫn như cũ)
  Future<bool> solveCase({
    required GameCase gameCase,
    required int sId,
    required int wId,
    required int rId,
    required Map<String, dynamic> finalMatrix,
  }) async {
    state = const AsyncLoading();

    final bool isCorrect = sId == gameCase.correctSuspectId &&
                           wId == gameCase.correctWeaponId &&
                           rId == gameCase.correctRoomId;

    if (!isCorrect) {
      state = const AsyncData(null);
      return false;
    }

    state = await AsyncValue.guard(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Khi phá án đúng, lưu luôn matrix_state hiện tại và set is_completed = true
      await _supabase.from('user_progress').upsert({
        'user_id': user.id,
        'case_id': gameCase.id,
        'matrix_state': finalMatrix,
        'is_completed': true,
      }, onConflict: 'user_id,case_id');

      await _supabase.from('profiles').update({
        'last_cleared_case': gameCase.id,
      }).eq('id', user.id);

      ref.invalidate(userProfileProvider);
    });
    return isCorrect;
  }
}

final caseProgressProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, caseId) async { //Lấy data ma trận đã lưu của người chơi
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) return {};

  final data = await supabase
      .from('user_progress')
      .select('matrix_state')
      .eq('user_id', user.id)
      .eq('case_id', caseId)
      .maybeSingle();

  return (data?['matrix_state'] as Map<String, dynamic>?) ?? {};
});
