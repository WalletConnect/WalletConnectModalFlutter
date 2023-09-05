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
    // final WalletConnectModalThemeData themeData =
    //     WalletConnectModalTheme.getData(context);

    return
        // Container(
        // decoration: BoxDecoration(
        //   color: themeData.overlay010,
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // child:
        MaterialButton(
      padding: const EdgeInsets.all(8),
      onPressed: onSelect,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      focusElevation: 1,
      hoverElevation: 1,
      highlightElevation: 1,
      child: child,
      // ),
    );
  }
}
