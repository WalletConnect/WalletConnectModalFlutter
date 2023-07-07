import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectIconButton extends StatelessWidget {
  const WalletConnectIconButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
    this.color,
    this.size = 26,
  });

  final String iconPath;
  final void Function() onPressed;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconPath,
        width: size,
        height: size,
        package: 'walletconnect_modal_flutter',
        colorFilter: ColorFilter.mode(
          color ?? WalletConnectModalTheme.getData(context).primary100,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
