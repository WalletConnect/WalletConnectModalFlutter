import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_icon_button.dart';

class WalletConnectModalNavBar extends StatelessWidget {
  const WalletConnectModalNavBar({
    Key? key,
    required this.title,
    this.onBack,
    this.actionWidget,
    required this.child,
  }) : super(key: key);

  final Widget title;
  final VoidCallback? onBack;
  final Widget? actionWidget;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    if (widgetStack.instance.canPop())
                      WalletConnectIconButton(
                        key: WalletConnectModalConstants.navbarBackButtonKey,
                        onPressed: () {
                          if (onBack != null) {
                            onBack!();
                          }
                          widgetStack.instance.pop();
                        },
                        iconPath: 'assets/icons/backward.svg',
                        size: 20,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: title,
              ),
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    if (actionWidget != null) actionWidget!,
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        child,
      ],
    );
  }
}
