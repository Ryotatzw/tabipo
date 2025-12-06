import 'package:flutter/material.dart';

class NoStretchBehavior extends ScrollBehavior {
  const NoStretchBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
