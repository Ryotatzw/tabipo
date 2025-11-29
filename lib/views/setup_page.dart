import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/family_view_model.dart';

class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.airport_shuttle, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'tabipoへようこそ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '離れて暮らす家族と、\n歩数でつながる旅に出かけましょう。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              
              // グループ作成ボタン
              ElevatedButton.icon(
                onPressed: () {
                  // ViewModelの「作成」を呼び出す
                  ref.read(familyGroupProvider.notifier).createFamilyGroup();
                },
                icon: const Icon(Icons.group_add),
                label: const Text('新しい家族グループを作る'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // 本当はここで招待コード入力画面へ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('招待機能は開発中です')),
                  );
                },
                child: const Text('招待コードで参加する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}