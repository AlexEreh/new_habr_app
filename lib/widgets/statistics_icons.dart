import 'package:flutter/material.dart';
import 'package:habr_app/utils/integer_to_text.dart';

typedef ValueToStringTransformer = String Function(int);

class Statistics extends StatelessWidget {
  final Widget leading;
  final int value;
  final TextStyle? textStyle;
  final ValueToStringTransformer valueToStringTransformer;

  const Statistics.widget({
    super.key,
    required this.value,
    required this.leading,
    this.textStyle,
    ValueToStringTransformer? valueTransformer,
  }) : valueToStringTransformer = valueTransformer ?? intToMetricPrefix;

  Statistics.icon({
    super.key,
    required IconData iconData,
    required this.value,
    double size = 20,
    this.textStyle,
    ValueToStringTransformer? valueTransformer,
  })  : valueToStringTransformer = valueTransformer ?? intToMetricPrefix,
        leading = Icon(iconData, size: size, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(
          width: 5,
        ),
        Text(
          valueToStringTransformer(value),
          style: textStyle,
        ),
      ],
    );
  }
}

class StatisticsFavoritesIcon extends StatelessWidget {
  final int favorites;
  final TextStyle? textStyle;

  const StatisticsFavoritesIcon(this.favorites, {super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Statistics.icon(
      value: favorites,
      iconData: Icons.bookmark,
      textStyle: textStyle,
    );
  }
}

class StatisticsScoreIcon extends StatelessWidget {
  final int score;
  final TextStyle? textStyle;

  Color scoreToColor(int score) {
    Color? color;
    switch (score.sign) {
      case -1:
        color = Colors.red[800];
        break;
      case 0:
        color = Colors.grey[600];
        break;
      case 1:
        color = Colors.green[800];
        break;
    }
    return color!;
  }

  const StatisticsScoreIcon(this.score, {super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Statistics.icon(
      iconData: Icons.equalizer,
      value: score,
      textStyle: textStyle!.copyWith(color: scoreToColor(score)),
      valueTransformer: (value) {
        String res = intToMetricPrefix(value);
        if (value > 0) res = '+$res';
        return res;
      },
    );
  }
}

class StatisticsViewsIcon extends StatelessWidget {
  final int views;
  final TextStyle? textStyle;

  const StatisticsViewsIcon(this.views, {super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Statistics.icon(
      iconData: Icons.remove_red_eye,
      value: views,
      textStyle: textStyle,
    );
  }
}

class StatisticsCommentsIcon extends StatelessWidget {
  final int comments;
  final TextStyle? textStyle;

  const StatisticsCommentsIcon(this.comments, {super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Statistics.icon(
      iconData: Icons.forum,
      value: comments,
      textStyle: textStyle,
    );
  }
}
