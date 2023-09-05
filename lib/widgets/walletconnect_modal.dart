import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/pages/help_page.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';
import 'package:walletconnect_modal_flutter/widgets/toast/walletconnect_modal_toast_manager.dart';
import 'package:walletconnect_modal_flutter/widgets/transition_container.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_icon_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModal extends StatefulWidget {
  const WalletConnectModal({
    super.key,
    this.startWidget,
  });

  final Widget? startWidget;

  @override
  State<WalletConnectModal> createState() => _WalletConnectModalState();
}

class _WalletConnectModalState extends State<WalletConnectModal> {
  bool _initialized = false;
  Widget? _body;

  // final List<WalletConnectModalState> _stateStack = [];

  @override
  void initState() {
    super.initState();

    widgetStack.instance.addListener(_widgetStackUpdated);

    if (widget.startWidget != null) {
      widgetStack.instance.add(widget.startWidget!);
    } else {
      widgetStack.instance.addDefault();
    }

    initialize();
  }

  @override
  void dispose() {
    widgetStack.instance.removeListener(_widgetStackUpdated);
    super.dispose();
  }

  Future<void> initialize() async {
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    final bool bottomSheet = platformUtils.instance.isBottomSheet();
    final BorderRadius outerContainerBorderRadius = bottomSheet
        ? BorderRadius.only(
            topLeft: Radius.circular(
              themeData.radius3XS,
            ),
            topRight: Radius.circular(
              themeData.radius3XS,
            ),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(
              themeData.radius3XS,
            ),
            topRight: Radius.circular(
              themeData.radius3XS,
            ),
            bottomLeft: Radius.circular(
              themeData.radiusM,
            ),
            bottomRight: Radius.circular(
              themeData.radiusM,
            ),
          );

    final BorderRadius innerContainerBorderRadius = bottomSheet
        ? BorderRadius.only(
            topLeft: Radius.circular(
              themeData.radiusM,
            ),
            topRight: Radius.circular(
              themeData.radiusM,
            ),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(
              themeData.radiusM,
            ),
            topRight: Radius.circular(
              themeData.radiusM,
            ),
            bottomLeft: Radius.circular(
              themeData.radiusM,
            ),
            bottomRight: Radius.circular(
              themeData.radiusM,
            ),
          );

    final double width = bottomSheet ? double.infinity : 600;
    const double modalWidgetHeight = 30;

    return Container(
      decoration: BoxDecoration(
        color: themeData.primary100,
        borderRadius: outerContainerBorderRadius,
      ),
      width: width,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/walletconnect_logo_full_white.svg',
                  height: modalWidgetHeight,
                  package: 'walletconnect_modal_flutter',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: _body?.key ==
                                WalletConnectModalConstants.helpPageKey
                            ? themeData.inverse100
                            : themeData.inverse000,
                        borderRadius: BorderRadius.circular(
                          modalWidgetHeight / 2,
                        ),
                      ),
                      height: modalWidgetHeight,
                      width: modalWidgetHeight,
                      child: WalletConnectIconButton(
                        key: WalletConnectModalConstants.helpButtonKey,
                        iconPath: 'assets/icons/help.svg',
                        color: _body?.key ==
                                WalletConnectModalConstants.helpPageKey
                            ? themeData.inverse000
                            : themeData.inverse100,
                        onPressed: () {
                          if (_body?.key ==
                              WalletConnectModalConstants.helpPageKey) {
                            widgetStack.instance.pop();
                            return;
                          } else if (widgetStack.instance.containsKey(
                            WalletConnectModalConstants.helpPageKey,
                          )) {
                            widgetStack.instance.popUntil(
                              WalletConnectModalConstants.helpPageKey,
                            );
                          } else {
                            widgetStack.instance.add(
                              const HelpPage(),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: themeData.inverse000,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      height: modalWidgetHeight,
                      width: modalWidgetHeight,
                      child: WalletConnectIconButton(
                        key: WalletConnectModalConstants.closeModalButtonKey,
                        iconPath: 'assets/icons/close.svg',
                        color: themeData.inverse100,
                        onPressed: () {
                          WalletConnectModalProvider.of(context)
                              .service
                              .close();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: innerContainerBorderRadius,
              color: themeData.background100,
            ),
            // padding: const EdgeInsets.only(
            //   bottom: 20,
            // ),
            child: Stack(
              children: [
                SafeArea(
                  child: TransitionContainer(
                    child: _buildBody(),
                  ),
                ),
                const WalletConnectModalToastManager(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!_initialized || _body == null) {
      return Container(
        constraints: const BoxConstraints(
          // minWidth: 300,
          // maxWidth: 400,
          minHeight: 300,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircularProgressIndicator(
              color: WalletConnectModalTheme.getData(context).primary100,
            ),
          ),
        ),
      );
    }

    return _body!;
  }

  void _widgetStackUpdated() {
    setState(() {
      _body = widgetStack.instance.getCurrent();
    });
  }
}
