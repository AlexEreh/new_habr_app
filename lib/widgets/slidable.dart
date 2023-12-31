import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableArchive extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onArchive;
  SlidableArchive({this.child, this.onArchive});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        child: child!,
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
                label: 'Archive',
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                icon: Icons.archive,
                onPressed: (context) => onArchive
            ),
          ],
        ),
    );
  }
}

class SlidableDelete extends StatelessWidget {
  final Key key;
  final Widget? child;
  final VoidCallback? onDelete;
  SlidableDelete({this.child, this.onDelete, required this.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      child: child!,
      endActionPane: ActionPane(
        extentRatio: 0,
        motion: DrawerMotion(),
        dismissible: DismissiblePane(
          dismissThreshold: 0.3,
            onDismissed: () => onDelete!()
        ),
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            icon: Icons.delete,
            onPressed: (BuildContext context) {  },
          ),
        ],
      ),
    );
  }
}

class SlidableArchiveDelete extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  SlidableArchiveDelete({this.child, this.onArchive, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).scaffoldBackgroundColor;
    return Slidable(
      child: child!,
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: DrawerMotion(),
          children: [
            SlidableAction(
                label: 'Archive',
                backgroundColor: color,
                icon: Icons.archive,
                onPressed: (context) => onArchive
            ),
            SlidableAction(
              label: 'Delete',
              backgroundColor: color,
              icon: Icons.delete,
              onPressed: (context) => onDelete,
            ),
          ]
      ),
    );
  }
}