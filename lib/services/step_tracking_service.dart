import 'package:flutter/foundation.dart';

/// Stub for integrating platform health services (Google Fit / Apple HealthKit).
///
/// Replace the implementations with platform channels or packages such as
/// `google_fit` (Android) and `health_kit_reporter` (iOS) to read daily steps.
abstract class StepTrackingService {
  Future<int> fetchTodaySteps();
}

class MockStepTrackingService implements StepTrackingService {
  @override
  Future<int> fetchTodaySteps() async {
    debugPrint('Using mock step tracking service');
    return 3500;
  }
}
