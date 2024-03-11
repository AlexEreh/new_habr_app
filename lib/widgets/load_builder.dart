import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

typedef ValueBuilder<Value> = Widget Function(BuildContext, Value);

class LoadBuilder<Left, Right> extends StatelessWidget {
  final Future<Either<Left, Right>> future;
  final ValueBuilder<Right> onRightBuilder;
  final ValueBuilder<Left>? onLeftBuilder;
  final ValueBuilder<dynamic> onErrorBuilder;

  const LoadBuilder({
    super.key,
    required this.future,
    required this.onRightBuilder,
    this.onLeftBuilder,
    required this.onErrorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<Left, Right>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return onErrorBuilder(context, snapshot.error);
            }
            return snapshot.data!.fold<Widget>(
                (err) => (onLeftBuilder ?? onErrorBuilder)(context, err),
                (data) => onRightBuilder(context, data));
          default:
            return const Text('Something went wrong');
        }
      },
    );
  }
}
