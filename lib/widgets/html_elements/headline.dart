import 'package:flutter/material.dart';

enum HeadLineType { h1, h2, h3, h4, h5, h6 }

class HeadLine extends StatelessWidget {
  final String? text;
  final HeadLineType? type;

  const HeadLine({super.key, this.text, this.type});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = {
      HeadLineType.h1: textTheme.displayLarge,
      HeadLineType.h2: textTheme.displayMedium,
      HeadLineType.h3: textTheme.displaySmall,
      HeadLineType.h4: textTheme.headlineMedium,
      HeadLineType.h5: textTheme.headlineSmall,
      HeadLineType.h6: textTheme.titleLarge,
    }[HeadLineType.h6]; // Todo: решить нужна ли впринципе эта таблица
    return Text(text!, style: textStyle);
  }
}
