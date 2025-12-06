import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_advice.dart';
import '../models/travel_question.dart';
import '../services/travel_advisor_service.dart';

final travelAdvisorServiceProvider = Provider((ref) => TravelAdvisorService());

final travelQuizProvider = NotifierProvider<TravelQuizNotifier, TravelQuizState>(
  TravelQuizNotifier.new,
);

class TravelQuizState {
  final List<TravelQuestion> questions;
  final Map<String, TravelQuestionOption> answers;
  final bool isLoading;
  final TravelAdvice? advice;

  const TravelQuizState({
    required this.questions,
    required this.answers,
    required this.isLoading,
    required this.advice,
  });

  bool get isComplete => answers.length == questions.length;

  TravelQuizState copyWith({
    List<TravelQuestion>? questions,
    Map<String, TravelQuestionOption>? answers,
    bool? isLoading,
    TravelAdvice? advice,
    bool clearAdvice = false,
  }) {
    return TravelQuizState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
      advice: clearAdvice ? null : advice ?? this.advice,
    );
  }
}

class TravelQuizNotifier extends Notifier<TravelQuizState> {
  @override
  TravelQuizState build() {
    return TravelQuizState(
      questions: _defaultQuestions,
      answers: {},
      isLoading: false,
      advice: null,
    );
  }

  void selectAnswer(String questionId, TravelQuestionOption option) {
    final updatedAnswers = Map<String, TravelQuestionOption>.from(state.answers);
    updatedAnswers[questionId] = option;
    state = state.copyWith(answers: updatedAnswers, clearAdvice: true);
  }

  Future<void> submit() async {
    if (!state.isComplete || state.isLoading) return;
    state = state.copyWith(isLoading: true, advice: state.advice);
    final service = ref.read(travelAdvisorServiceProvider);
    final advice = await service.createAdvice(answers: state.answers);
    state = state.copyWith(isLoading: false, advice: advice);
  }

  void reset() {
    state = TravelQuizState(
      questions: _defaultQuestions,
      answers: {},
      isLoading: false,
      advice: null,
    );
  }
}

const _defaultQuestions = [
  TravelQuestion(
    id: 'pace',
    title: '旅のスタイルはどちらが好き？',
    options: [
      TravelQuestionOption(
        id: 'nature_slow',
        label: 'のんびり自然派',
        description: '静かな場所でゆっくり過ごしたい',
      ),
      TravelQuestionOption(
        id: 'city_fast',
        label: '街歩き派',
        description: '活気ある街で刺激を受けたい',
      ),
    ],
  ),
  TravelQuestion(
    id: 'food',
    title: '食べたいのは？',
    options: [
      TravelQuestionOption(
        id: 'seafood',
        label: '海の幸',
        description: '新鮮な魚介を楽しみたい',
      ),
      TravelQuestionOption(
        id: 'sweets',
        label: 'スイーツ巡り',
        description: '甘いものを食べ歩きしたい',
      ),
    ],
  ),
  TravelQuestion(
    id: 'activity',
    title: '移動手段は？',
    options: [
      TravelQuestionOption(
        id: 'hiking',
        label: '歩き&トレッキング',
        description: '歩数を稼いで達成感を味わいたい',
      ),
      TravelQuestionOption(
        id: 'bike',
        label: 'レンタサイクル',
        description: '効率よく移動してたくさん巡りたい',
      ),
    ],
  ),
];
