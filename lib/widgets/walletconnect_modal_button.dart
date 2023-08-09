import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModalButton extends StatelessWidget {
  const WalletConnectModalButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 100,
  });

  final Widget child;
  final void Function()? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    // No onPressed means the button is disabled and grayed out.
    if (onPressed == null) {
      return MaterialButton(
        onPressed: () {},
        color: themeData.overlay030,
        disabledColor: themeData.overlay030,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
        child: child,
      );
    } else {
      return MaterialButton(
        onPressed: onPressed,
        color: themeData.primary100,
        focusColor: themeData.primary090,
        hoverColor: themeData.primary090,
        highlightColor: themeData.primary080,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
        child: child,
      );
    }
  }
}
