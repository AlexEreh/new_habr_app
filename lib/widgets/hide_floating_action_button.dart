import 'package:flutter/material.dart';

class HideFloatingActionButton extends StatelessWidget {
  final bool visible;
  final Widget? child;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Duration duration;

  const HideFloatingActionButton({super.key,
    this.visible = true,
    this.child,
    this.onPressed,
    this.tooltip,
    required
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
        },
        child: Visibility(
            visible: visible,
            key: UniqueKey(),
            child: FloatingActionButton(
              tooltip: tooltip,
              onPressed: onPressed,
              child: child,
            )
        )
    );
  }

}