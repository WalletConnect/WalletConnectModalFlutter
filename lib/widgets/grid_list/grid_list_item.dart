import 'package:flutter/material.dart';

class GridListItem extends StatelessWidget {
  const GridListItem({
    super.key,
    required this.onSelect,
    required this.child,
  });

  final void Function() onSelect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(0),
      onPressed: onSelect,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      focusElevation: 1,
      hoverElevation: 1,
      highlightElevation: 1,
      child: child,
    );
  }
}
