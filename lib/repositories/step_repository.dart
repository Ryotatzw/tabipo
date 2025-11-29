class StepRepository {
  Future<int> fetchDailySteps() async {
    await Future.delayed(const Duration(seconds: 1));
    return 5678; // 仮の歩数
  }
}