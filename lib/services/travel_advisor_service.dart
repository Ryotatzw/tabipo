import 'dart:async';

import '../models/travel_advice.dart';
import '../models/travel_question.dart';

/// TravelAdvisorService is responsible for converting quiz answers
/// into a [TravelAdvice]. In production this should call Gemini or another
/// LLM-powered endpoint, but for now it returns deterministic dummy data
/// so that the UI can be wired end-to-end.
class TravelAdvisorService {
  Future<TravelAdvice> createAdvice({
    required Map<String, TravelQuestionOption> answers,
  }) async {
    // TODO: Replace this mock implementation with a real Gemini API call.
    await Future.delayed(const Duration(seconds: 1));

    // Simple heuristic based on the first answer to keep the UI dynamic.
    if (answers.values.any((option) => option.id.contains('nature'))) {
      return const TravelAdvice(
        typeName: '自然派アドベンチャラー',
        recommendedDestination: '北海道・知床五湖',
        message: '静かな湖畔と野生動物を巡るルートがおすすめです。家族でゆったり歩きましょう。',
      );
    }

    return const TravelAdvice(
      typeName: 'カルチャーシーカー',
      recommendedDestination: '京都・祇園エリア',
      message: '歴史的な街並みと食文化を味わうコースがお似合いです。',
    );
  }
}
