class TravelQuestionOption {
  final String id;
  final String label;
  final String description;

  const TravelQuestionOption({
    required this.id,
    required this.label,
    required this.description,
  });
}

class TravelQuestion {
  final String id;
  final String title;
  final List<TravelQuestionOption> options;

  const TravelQuestion({
    required this.id,
    required this.title,
    required this.options,
  }) : assert(options.length == 2, 'Only two options supported');
}
