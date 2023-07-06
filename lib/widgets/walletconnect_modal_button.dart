import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModalButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const WalletConnectModalButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return MaterialButton(
      onPressed: onPressed,
      color: themeData.primary100,
      focusColor: themeData.primary090,
      hoverColor: themeData.primary090,
      highlightColor: themeData.primary080,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          themeData.radius4XS,
        ),
      ),
      child: child,
    );
  }
}
