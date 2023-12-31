import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableArchive extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onArchive;
  const SlidableArchive({super.key, this.child, this.onArchive});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
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
        child: child!,
    );
  }
}

class SlidableDelete extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onDelete;
  const SlidableDelete({super.key, this.child, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        extentRatio: 0,
        motion: const DrawerMotion(),
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
      child: child!,
    );
  }
}

class SlidableArchiveDelete extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  const SlidableArchiveDelete({super.key, this.child, this.onArchive, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).scaffoldBackgroundColor;
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
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
      child: child!,
    );
  }
}