import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModalButton extends StatelessWidget {
  const WalletConnectModalButton({
    super.key,
    required this.child,
    this.onPressed,
    this.disabled = false,
    this.borderRadius = 100,
    this.height = 28,
    this.padding,
  });

  final Widget child;
  final void Function()? onPressed;
  final bool disabled;
  final double borderRadius;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (height != null) {
      return SizedBox(height: height, child: _buildButton(context));
    } else {
      return _buildButton(context);
    }

    // No onPressed means the button is disabled and grayed out.
  }

  Widget _buildButton(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    if (disabled) {
      return MaterialButton(
        onPressed: onPressed ?? () {},
        color: themeData.background300,
        // disabledColor: themeData.overlay005,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          side: BorderSide(
            color: themeData.overlay010,
            // strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        elevation: 1,
        focusElevation: 1,
        hoverElevation: 1,
        highlightElevation: 1,
        padding: padding,
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
        padding: padding,
        child: child,
      );
    }
  }
}
