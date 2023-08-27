import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

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
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return Container(
      margin: const EdgeInsets.all(4),
      child: MaterialButton(
        padding: const EdgeInsets.all(4),
        onPressed: onSelect,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusColor: themeData.overlay020,
        hoverColor: themeData.overlay010,
        child: child,
      ),
    );
  }
}
