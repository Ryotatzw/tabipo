import "user.dart";

class FamilyGroup {
  final String id;
  final List<User> members;

  FamilyGroup({required this.id, required this.members});

  int get totalSteps {
    int sum = 0;
    for (var member in members) {
      sum += member.steps;
    }
    return sum;
  }
}