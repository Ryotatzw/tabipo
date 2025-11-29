import '../models/user.dart';
import '../models/family_group.dart';

class FamilyRepository {
  // 内部にデータを保持しておく変数（最初はnull = グループ未所属）
  FamilyGroup? _currentGroup;

  // データを取得する
  Future<FamilyGroup?> fetchFamilyGroup() async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    return _currentGroup; // 最初は null が返る
  }

  // ★追加: グループを新規作成する機能
  Future<void> createGroup(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    // ダミーのグループデータを作成してセット
    _currentGroup = FamilyGroup(
      id: 'group_new_001',
      members: [
        User(id: 'dad', name: '父', steps: 8000),
        User(id: 'mom', name: '母', steps: 6500),
        User(id: userId, name: '自分', steps: 0), // 最初は0歩
      ],
    );
  }
}