import 'package:flutter/material.dart';

class BlockQuote extends StatelessWidget {
  final Widget? child;

  const BlockQuote({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: themeData.primaryColor,
            width: 4,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: child,
    );
  }
}
