import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_group.dart';
import '../models/travel_advice.dart';
import '../repositories/family_repository.dart';

// リポジトリはアプリ内で1つだけ（シングルトン）にしてデータを保持させる
final familyRepositoryProvider = Provider((ref) => FamilyRepository());

// ★変更: Notifierを使って、「データの変更」を扱えるようにする
final familyGroupProvider = AsyncNotifierProvider<FamilyGroupNotifier, FamilyGroup?>(() {
  return FamilyGroupNotifier();
});

class FamilyGroupNotifier extends AsyncNotifier<FamilyGroup?> {
  // 初期化処理：データを取ってくる
  @override
  Future<FamilyGroup?> build() async {
    final repository = ref.read(familyRepositoryProvider);
    return repository.fetchFamilyGroup();
  }

  // ★追加: グループ作成アクション
  Future<void> createFamilyGroup({TravelAdvice? advice}) async {
    state = const AsyncValue.loading(); // 読み込み中にする
    try {
      final repository = ref.read(familyRepositoryProvider);
      await repository.createGroup('me', travelAdvice: advice); // グループ作成実行

      // データを再取得して画面を更新
      final newGroup = await repository.fetchFamilyGroup();
      state = AsyncValue.data(newGroup);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> joinFamilyGroup(String inviteCode) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(familyRepositoryProvider);
      await repository.joinGroup(inviteCode);
      final newGroup = await repository.fetchFamilyGroup();
      state = AsyncValue.data(newGroup);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }
}
