import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_group.dart';
import '../repositories/family_repository.dart';

final familyRepositoryProvider = Provider((ref) => FamilyRepository());

final familyGroupProvider = AsyncNotifierProvider<FamilyGroupNotifier, FamilyGroup?>(() {
  return FamilyGroupNotifier();
});

// Notifierクラスの定義
class FamilyGroupNotifier extends AsyncNotifier<FamilyGroup?> {
  @override
  Future<FamilyGroup?> build() async {
    final repository = ref.read(familyRepositoryProvider);
    return repository.fetchFamilyGroup();
  }

  Future<void> createFamilyGroup() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(familyRepositoryProvider);
      await repository.createGroup('me');
      
      final newGroup = await repository.fetchFamilyGroup();
      state = AsyncValue.data(newGroup);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}