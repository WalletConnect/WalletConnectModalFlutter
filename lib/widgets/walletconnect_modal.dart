import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/launch_url_exception.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/pages/get_wallet_page.dart';
import 'package:walletconnect_modal_flutter/pages/help_page.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';
import 'package:walletconnect_modal_flutter/widgets/qr_code_widget.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list.dart';
import 'package:walletconnect_modal_flutter/widgets/toast/walletconnect_modal_toast_manager.dart';
import 'package:walletconnect_modal_flutter/widgets/transition_container.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_icon_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar_title.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_search_bar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModal extends StatefulWidget {
  const WalletConnectModal({
    super.key,
    required this.service,
    this.startWidget,
  });

  final IWalletConnectModalService service;
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
      final PlatformType pType = platformUtils.instance.getPlatformType();

      // Choose the state based on platform
      if (pType == PlatformType.mobile) {
        _addWalletListShort();
      } else if (pType == PlatformType.desktop || pType == PlatformType.web) {
        _addQrCodeAndWalletList();
      }
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
    const double modalWidgetHeight = 32;

    return Container(
      decoration: BoxDecoration(
        color: themeData.primary100,
        borderRadius: outerContainerBorderRadius,
      ),
      constraints: const BoxConstraints(
        maxHeight: 2000,
      ),
      width: width,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
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
                        key: const Key(
                          StringConstants.walletConnectModalHelpButtonKey,
                        ),
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
                            _addHelp();
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
                        key: const Key(
                          StringConstants.walletConnectModalCloseButtonKey,
                        ),
                        iconPath: 'assets/icons/close.svg',
                        color: themeData.inverse100,
                        onPressed: () {
                          widget.service.close();
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
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Stack(
              children: [
                TransitionContainer(
                  child: _buildBody(),
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
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: WalletConnectModalTheme.getData(context).primary100,
            ),
          ),
        ),
      );
    }

    return _body!;
  }

  void _addQrCode() {
    widgetStack.instance.add(
      WalletConnectModalNavBar(
        key: WalletConnectModalConstants.qrCodePageKey,
        title: const WalletConnectModalNavbarTitle(
          title: 'Scan QR Code',
        ),
        onBack: widgetStack.instance.pop,
        actionWidget: WalletConnectIconButton(
          iconPath: 'assets/icons/copy.svg',
          onPressed: _copyQrCodeToClipboard,
        ),
        child: QRCodePage(
          service: widget.service,
          logoPath: 'assets/walletconnect_logo_white.png',
        ),
      ),
    );
  }

  void _addWalletListShort() {
    widgetStack.instance.add(
      WalletConnectModalNavBar(
        key: WalletConnectModalConstants.walletListShortPageKey,
        title: const WalletConnectModalNavbarTitle(
          title: 'Connect your wallet',
        ),
        actionWidget: WalletConnectIconButton(
          iconPath: 'assets/icons/qr_code.svg',
          onPressed: _addQrCode,
        ),
        child: GridList<WalletData>(
          state: GridListState.short,
          provider: explorerService.instance!,
          viewLongList: _addWalletListLong,
          onSelect: _onWalletDataSelected,
        ),
      ),
    );
  }

  void _addWalletListLong() {
    widgetStack.instance.add(
      WalletConnectModalNavBar(
        key: WalletConnectModalConstants.walletListLongPageKey,
        title: WalletConnectModalSearchBar(
          hintText:
              'Search ${platformUtils.instance.getPlatformType().name} wallets',
          onSearch: _updateSearch,
        ),
        onBack: widgetStack.instance.pop,
        child: GridList<WalletData>(
          // key: ValueKey('${GridListState.long}$_searchQuery'),
          state: GridListState.long,
          provider: explorerService.instance!,
          viewLongList: _addWalletListLong,
          onSelect: _onWalletDataSelected,
        ),
      ),
    );
  }

  void _addQrCodeAndWalletList() {
    widgetStack.instance.add(
      WalletConnectModalNavBar(
        key: WalletConnectModalConstants.qrCodeAndWalletListPageKey,
        title: const WalletConnectModalNavbarTitle(
          title: 'Connect your wallet',
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QRCodePage(
              service: widget.service,
              logoPath: 'assets/walletconnect_logo_white.png',
            ),
            GridList(
              state: GridListState.extraShort,
              provider: explorerService.instance!,
              viewLongList: _addWalletListLong,
              onSelect: _onWalletDataSelected,
            ),
          ],
        ),
      ),
    );
  }

  void _addHelp() {
    widgetStack.instance.add(
      WalletConnectModalNavBar(
        key: WalletConnectModalConstants.helpPageKey,
        title: const WalletConnectModalNavbarTitle(
          title: 'Help',
        ),
        onBack: widgetStack.instance.pop,
        child: HelpPage(
          getAWallet: () {
            _addGetAWallet();
          },
        ),
      ),
    );
  }

  void _addGetAWallet() {
    widgetStack.instance.add(
      WalletConnectModalNavBar(
        key: WalletConnectModalConstants.getAWalletPageKey,
        title: const WalletConnectModalNavbarTitle(
          title: 'Get a wallet',
        ),
        onBack: widgetStack.instance.pop,
        child: GetWalletPage(
          service: explorerService.instance!,
        ),
      ),
    );
  }

  bool _walletSelected = false;

  Future<void> _onWalletDataSelected(WalletData item) async {
    if (_walletSelected) {
      return;
    }
    _walletSelected = true;

    LoggerUtil.logger.v(
      'Selected ${item.listing.name}. Installed: ${item.installed} Item info: $item.',
    );
    try {
      await widget.service.rebuildConnectionUri();
      await urlUtils.instance.navigateDeepLink(
        nativeLink: item.listing.mobile.native,
        universalLink: item.listing.mobile.universal,
        wcURI: widget.service.wcUri!,
      );
    } on LaunchUrlException catch (e) {
      toastUtils.instance.show(
        ToastMessage(
          type: ToastType.error,
          text: e.message,
        ),
      );
    }

    _walletSelected = false;
  }

  Future<void> _copyQrCodeToClipboard() async {
    await Clipboard.setData(
      ClipboardData(
        text: widget.service.wcUri!,
      ),
    );
    toastUtils.instance.show(
      ToastMessage(
        type: ToastType.info,
        text: 'QR Copied',
      ),
    );
  }

  void _updateSearch(String query) {
    explorerService.instance!.filterList(query: query);
  }

  void _widgetStackUpdated() {
    setState(() {
      _body = widgetStack.instance.getCurrent();
    });
  }
}
