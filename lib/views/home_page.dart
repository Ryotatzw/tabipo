import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_group.dart'; // import忘れずに

class HomePage extends ConsumerWidget {
  // SetupPageから渡される FamilyGroup を受け取る
  final FamilyGroup familyGroup;

  const HomePage({super.key, required this.familyGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('北海道・知床への旅')), // [cite: 57]
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. メインビジュアル（旅の進捗）
            _buildHeroSection(context, familyGroup),
            
            // 2. メンバーリスト
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('旅の仲間', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...familyGroup.members.map((member) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(member.name[0])),
                      title: Text(member.name),
                      trailing: Text('${member.steps} 歩', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: LinearProgressIndicator(value: member.steps / 10000), // 1万歩目標のバー
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // メインの絶景エリア
  Widget _buildHeroSection(BuildContext context, FamilyGroup group) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        // 本来はここに絶景画像を入れる: image: DecorationImage(...)
      ),
      child: Stack(
        children: [
          // 背景を少し暗くする
          Container(color: Colors.black.withOpacity(0.3)),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('現在の目的地', style: TextStyle(color: Colors.white70)),
                const Text('知床五湖', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), // [cite: 47]
                const Spacer(),
                const Text('ゴールまで あと40%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // [cite: 49]
                const SizedBox(height: 8),
                // 全体の進捗バー
                LinearProgressIndicator(
                  value: 0.6, // 60%進んでいる
                  backgroundColor: Colors.white30,
                  color: Colors.orangeAccent,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 8),
                Text('合計 ${group.totalSteps} pt', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}