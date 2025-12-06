import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_group.dart';
import '../widgets/no_stretch_behavior.dart';

class HomePage extends ConsumerWidget {
  // SetupPageから渡される FamilyGroup を受け取る
  final FamilyGroup familyGroup;

  const HomePage({super.key, required this.familyGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: Text(familyGroup.destination),
      ),
      body: ScrollConfiguration(
        behavior: const NoStretchBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroSection(context, familyGroup),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressChart(familyGroup),
                    const SizedBox(height: 24),
                    _buildInviteCodeCard(),
                    const SizedBox(height: 24),
                    const Text('旅の仲間',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...familyGroup.members.map((member) => Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text(member.name[0])),
                            title: Text(member.name),
                            trailing: Text('${member.steps} 歩',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: LinearProgressIndicator(
                              value: member.steps / 10000,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // メインの絶景エリア
  Widget _buildHeroSection(BuildContext context, FamilyGroup group) {
    final progress = group.progressToGoal.clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      height: 260,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.25)),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.tripType,
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                Text(group.destination,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('ゴールまで ${(100 - progress * 100).round()}%',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white30,
                  color: Colors.orangeAccent,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 8),
                Text('合計 ${group.totalSteps} 歩 / 目標 ${group.goalSteps} 歩',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(FamilyGroup group) {
    final maxStep = (group.dailySteps.isEmpty
            ? 0
            : group.dailySteps.reduce((a, b) => a > b ? a : b)) +
        1000;
    final bars = group.dailySteps
        .asMap()
        .entries
        .map(
          (entry) => _BarEntry(
            label: 'Day ${entry.key + 1}',
            value: entry.value.toDouble(),
            max: maxStep.toDouble(),
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('家族の歩数推移',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('過去1週間の合計歩数から、目標までの進み具合をチェック'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueGrey.shade50,
          ),
          child: Column(
            children: [
              Row(
                children: bars
                    .map(
                      (bar) => Expanded(
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: 140,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 140 * (bar.value / bar.max).clamp(0.0, 1.0),
                                width: 24,
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(bar.label,
                                style:
                                    const TextStyle(fontSize: 12, color: Colors.black54)),
                            Text('${bar.value.toInt()}歩',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Text(
                '目標まであと ${((group.goalSteps - group.totalSteps) > 0 ? (group.goalSteps - group.totalSteps) : 0)} 歩',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInviteCodeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.qr_code, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('家族を招待',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('共有コード: ${familyGroup.inviteCode}',
                      style: const TextStyle(fontSize: 14)),
                  const Text('コードを共有すると、他のスマホから参加できます。'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('招待コードをコピーしました (ダミー)')),
                );
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarEntry {
  final String label;
  final double value;
  final double max;

  _BarEntry({required this.label, required this.value, required this.max});
}
