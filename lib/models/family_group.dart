import 'user.dart';

class FamilyGroup {
  final String id;
  final String inviteCode;
  final String tripType;
  final String destination;
  final int goalSteps;
  final List<int> dailySteps;
  final List<User> members;

  FamilyGroup({
    required this.id,
    required this.inviteCode,
    required this.tripType,
    required this.destination,
    required this.goalSteps,
    required this.dailySteps,
    required this.members,
  });

  int get totalSteps {
    int sum = 0;
    for (var member in members) {
      sum += member.steps;
    }
    return sum;
  }

  double get progressToGoal => goalSteps == 0 ? 0 : totalSteps / goalSteps;
}
