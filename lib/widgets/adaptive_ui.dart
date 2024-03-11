import 'package:flutter/material.dart';

class CenterAdaptiveConstraint extends StatelessWidget {
  final Widget child;

  const CenterAdaptiveConstraint({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: child,
      ),
    );
  }
}

class DefaultConstraints extends StatelessWidget {
  final Widget child;

  const DefaultConstraints({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 880,
        child: child,
      ),
    );
  }
}
