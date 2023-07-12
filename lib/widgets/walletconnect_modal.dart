import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/models/launch_url_exception.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/pages/get_wallet_page.dart';
import 'package:walletconnect_modal_flutter/pages/help_page.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
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
    this.startState,
  });

  final IWalletConnectModalService service;
  final WalletConnectModalState? startState;

  @override
  State<WalletConnectModal> createState() => _WalletConnectModalState();
}

class _WalletConnectModalState extends State<WalletConnectModal> {
  bool _initialized = false;

  final List<WalletConnectModalState> _stateStack = [];

  @override
  void initState() {
    super.initState();

    if (widget.startState != null) {
      _stateStack.add(widget.startState!);
    } else {
      final PlatformType pType = platformUtils.instance.getPlatformType();

      // Choose the state based on platform
      if (pType == PlatformType.mobile) {
        _stateStack.add(WalletConnectModalState.walletListShort);
      } else if (pType == PlatformType.desktop || pType == PlatformType.web) {
        _stateStack.add(WalletConnectModalState.qrCodeAndWalletList);
      }
    }

    initialize();
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
                        color: _stateStack.last == WalletConnectModalState.help
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
                        color: _stateStack.last == WalletConnectModalState.help
                            ? themeData.inverse000
                            : themeData.inverse100,
                        onPressed: () {
                          if (_stateStack
                              .contains(WalletConnectModalState.help)) {
                            _popUntil(WalletConnectModalState.help);
                          } else {
                            setState(() {
                              _stateStack.add(WalletConnectModalState.help);
                            });
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
    if (!_initialized) {
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

    switch (_stateStack.last) {
      case WalletConnectModalState.qrCode:
        return WalletConnectModalNavBar(
          key: Key(WalletConnectModalState.qrCode.name),
          title: const WalletConnectModalNavbarTitle(
            title: 'Scan QR Code',
          ),
          onBack: _pop,
          actionWidget: WalletConnectIconButton(
            iconPath: 'assets/icons/copy.svg',
            onPressed: _copyQrCodeToClipboard,
          ),
          child: QRCodePage(
            qrData: widget.service.wcUri!,
            logoPath: 'assets/walletconnect_logo_white.png',
          ),
        );
      case WalletConnectModalState.walletListShort:
        return WalletConnectModalNavBar(
          key: Key(WalletConnectModalState.walletListShort.name),
          title: const WalletConnectModalNavbarTitle(
            title: 'Connect your wallet',
          ),
          actionWidget: WalletConnectIconButton(
            iconPath: 'assets/icons/qr_code.svg',
            onPressed: _toQrCode,
          ),
          child: GridList<WalletData>(
            state: GridListState.short,
            provider: widget.service.explorerService,
            viewLongList: _viewLongWalletList,
            onSelect: _onWalletDataSelected,
          ),
        );
      case WalletConnectModalState.walletListLong:
        return WalletConnectModalNavBar(
          key: Key(WalletConnectModalState.walletListLong.name),
          title: WalletConnectModalSearchBar(
            hintText:
                'Search ${platformUtils.instance.getPlatformType().name} wallets',
            onSearch: _updateSearch,
          ),
          onBack: _pop,
          child: GridList<WalletData>(
            // key: ValueKey('${GridListState.long}$_searchQuery'),
            state: GridListState.long,
            provider: widget.service.explorerService,
            viewLongList: _viewLongWalletList,
            onSelect: _onWalletDataSelected,
          ),
        );
      case WalletConnectModalState.qrCodeAndWalletList:
        return WalletConnectModalNavBar(
          key: Key(
            WalletConnectModalState.qrCodeAndWalletList.name,
          ),
          title: const WalletConnectModalNavbarTitle(
            title: 'Connect your wallet',
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              QRCodePage(
                qrData: widget.service.wcUri!,
                logoPath: 'assets/walletconnect_logo_white.png',
              ),
              GridList(
                state: GridListState.extraShort,
                provider: widget.service.explorerService,
                viewLongList: _viewLongWalletList,
                onSelect: _onWalletDataSelected,
              ),
            ],
          ),
        );
      case WalletConnectModalState.chainList:
        return WalletConnectModalNavBar(
          // TODO: Update this to display chains, not wallets
          key: Key(WalletConnectModalState.chainList.name),
          title: const WalletConnectModalNavbarTitle(
            title: 'Select network',
          ),
          child: GridList(
            state: GridListState.extraShort,
            provider: widget.service.explorerService,
            viewLongList: _viewLongWalletList,
            onSelect: _onWalletDataSelected,
          ),
        );
      case WalletConnectModalState.help:
        return WalletConnectModalNavBar(
          key: Key(WalletConnectModalState.help.name),
          title: const WalletConnectModalNavbarTitle(
            title: 'Help',
          ),
          onBack: _pop,
          child: HelpPage(
            getAWallet: () {
              setState(() {
                _stateStack.add(WalletConnectModalState.getAWallet);
              });
            },
          ),
        );
      case WalletConnectModalState.getAWallet:
        return WalletConnectModalNavBar(
          key: Key(WalletConnectModalState.getAWallet.name),
          title: const WalletConnectModalNavbarTitle(
            title: 'Get a wallet',
          ),
          onBack: _pop,
          child: GetWalletPage(
            service: widget.service.explorerService,
          ),
        );
      default:
        return Container();
    }
  }

  Future<void> _onWalletDataSelected(WalletData item) async {
    LoggerUtil.logger.v(
      'Selected ${item.listing.name}. Installed: ${item.installed} Item info: $item.',
    );
    try {
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
  }

  void _viewLongWalletList() {
    setState(() {
      _stateStack.add(WalletConnectModalState.walletListLong);
    });
  }

  void _pop() {
    setState(() {
      // Remove all of the elements until we get to the help state
      final state = _stateStack.removeLast();

      if (state == WalletConnectModalState.walletListLong) {
        widget.service.explorerService.filterList(query: '');
      }
    });
  }

  void _popUntil(WalletConnectModalState targetState) {
    setState(() {
      // Remove all of the elements until we get to the help state
      WalletConnectModalState removedState = _stateStack.removeLast();
      while (removedState != WalletConnectModalState.help) {
        removedState = _stateStack.removeLast();

        if (removedState == WalletConnectModalState.walletListLong) {
          widget.service.explorerService.filterList(query: '');
        }
      }
    });
  }

  void _toQrCode() {
    setState(() {
      _stateStack.add(WalletConnectModalState.qrCode);
    });
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
    widget.service.explorerService.filterList(query: query);
  }
}
