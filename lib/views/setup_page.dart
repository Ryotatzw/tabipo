import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/travel_question.dart';
import '../view_models/family_view_model.dart';
import '../view_models/travel_quiz_view_model.dart';
import '../widgets/no_stretch_behavior.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final TextEditingController _inviteCodeController = TextEditingController();

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(travelQuizProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('家族グループのセットアップ'),
      ),
      body: ScrollConfiguration(
        behavior: const NoStretchBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.airport_shuttle, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'tabipoへようこそ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildTravelQuiz(context, quizState),
                const SizedBox(height: 24),
                _buildAdviceCard(quizState),
                const SizedBox(height: 32),
                _buildGroupActions(context, quizState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTravelQuiz(BuildContext context, TravelQuizState quizState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '旅行タイプ診断',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          '2択の質問に答えて、Gemini APIを使ったおすすめ提案に備えましょう。',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ...quizState.questions.map((q) => _QuizQuestionCard(question: q)),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: quizState.isComplete && !quizState.isLoading
              ? () => ref.read(travelQuizProvider.notifier).submit()
              : null,
          icon: const Icon(Icons.bolt),
          label: Text(quizState.isLoading ? '診断中...' : '診断しておすすめをもらう'),
        ),
        if (!quizState.isComplete)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('すべての質問に答えてください', style: TextStyle(color: Colors.redAccent)),
          ),
      ],
    );
  }

  Widget _buildAdviceCard(TravelQuizState quizState) {
    final advice = quizState.advice;
    if (advice == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('診断結果がここに表示されます。Gemini APIを接続すれば、さらにリッチな提案が届きます。'),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.orange),
                const SizedBox(width: 8),
                Text(advice.typeName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Text('おすすめの旅先: ${advice.recommendedDestination}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(advice.message),
            const SizedBox(height: 12),
            const Text(
              'Gemini APIに差し替える場合は、TravelAdvisorServiceのcreateAdviceを置き換えてください。',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupActions(BuildContext context, TravelQuizState quizState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('家族グループを準備', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await ref
                  .read(familyGroupProvider.notifier)
                  .createFamilyGroup(advice: quizState.advice);
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('作成に失敗しました: $e')));
              }
            }
          },
          icon: const Icon(Icons.group_add),
          label: const Text('新しい家族グループを作る'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _inviteCodeController,
          decoration: const InputDecoration(
            labelText: '招待コードで参加する',
            hintText: '例: JOIN-4821',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            try {
              await ref
                  .read(familyGroupProvider.notifier)
                  .joinFamilyGroup(_inviteCodeController.text.trim());
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('参加に失敗しました: $e')));
              }
            }
          },
          child: const Text('招待コードで参加する'),
        ),
      ],
    );
  }
}

class _QuizQuestionCard extends ConsumerWidget {
  final TravelQuestion question;

  const _QuizQuestionCard({required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(travelQuizProvider);
    final selected = state.answers[question.id]?.id;
    final notifier = ref.read(travelQuizProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...question.options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: selected == opt.id
                      ? Colors.blue.shade50
                      : Colors.grey.shade50,
                  leading: Icon(
                    selected == opt.id ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: selected == opt.id ? Colors.blue : Colors.grey,
                  ),
                  title: Text(opt.label),
                  subtitle: Text(opt.description),
                  onTap: () => notifier.selectAnswer(question.id, opt),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
