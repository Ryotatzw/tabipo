import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/family_view_model.dart';
import 'home_page.dart';
import 'setup_page.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 家族データを監視
    final asyncValue = ref.watch(familyGroupProvider);

    return asyncValue.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('エラー: $err'))),
      data: (familyGroup) {
        // データがあるかチェック
        if (familyGroup == null) {
          // なければセットアップ画面へ
          return const SetupPage();
        } else {
          // あればホーム画面へ（データを渡す）
          return HomePage(familyGroup: familyGroup);
        }
      },
    );
  }
}