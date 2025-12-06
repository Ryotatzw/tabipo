import '../models/family_group.dart';
import '../models/travel_advice.dart';
import '../models/user.dart';

class FamilyRepository {
  // 内部にデータを保持しておく変数（最初はnull = グループ未所属）
  FamilyGroup? _currentGroup;

  // データを取得する
  Future<FamilyGroup?> fetchFamilyGroup() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentGroup; // 最初は null が返る
  }

  // ★グループを新規作成する機能
  Future<void> createGroup(String userId, {TravelAdvice? travelAdvice}) async {
    await Future.delayed(const Duration(seconds: 1));
    // ダミーのグループデータを作成してセット
    _currentGroup = FamilyGroup(
      id: 'group_new_001',
      inviteCode: 'JOIN-4821',
      tripType: travelAdvice?.typeName ?? '自然派アドベンチャラー',
      destination:
          travelAdvice?.recommendedDestination ?? '北海道・知床五湖 (デモ)',
      goalSteps: 40000,
      dailySteps: const [4200, 5300, 6100, 7200, 6800, 7600, 8200],
      members: [
        const User(id: 'dad', name: '父', steps: 8000),
        const User(id: 'mom', name: '母', steps: 6500),
        User(id: userId, name: '自分', steps: 0), // 最初は0歩
      ],
    );
  }

  // ★招待コードで参加する機能
  Future<void> joinGroup(String inviteCode) async {
    await Future.delayed(const Duration(seconds: 1));
    if (inviteCode.toUpperCase() != 'JOIN-4821') {
      throw Exception('招待コードが正しくありません');
    }

    _currentGroup = FamilyGroup(
      id: 'group_shared_001',
      inviteCode: 'JOIN-4821',
      tripType: 'カルチャーシーカー',
      destination: '京都・祇園エリア',
      goalSteps: 42000,
      dailySteps: const [3800, 5000, 5500, 6100, 6800, 7100, 7900],
      members: const [
        User(id: 'sibling', name: '兄', steps: 7200),
        User(id: 'sister', name: '姉', steps: 5400),
        User(id: 'me', name: '自分', steps: 3000),
      ],
    );
  }
}
