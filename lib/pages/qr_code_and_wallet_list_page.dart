import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/pages/wallet_list_long_page.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_wallet_item.dart';
import 'package:walletconnect_modal_flutter/widgets/qr_code_widget.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar_title.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';

class QRCodeAndWalletListPage extends StatelessWidget {
  const QRCodeAndWalletListPage()
      : super(key: WalletConnectModalConstants.qrCodeAndWalletListPageKey);

  @override
  Widget build(BuildContext context) {
    final IWalletConnectModalService service =
        WalletConnectModalProvider.of(context).service;
    final pType = platformUtils.instance.getPlatformType();
    return WalletConnectModalNavBar(
      title: const WalletConnectModalNavbarTitle(
        title: 'Connect your wallet',
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (pType == PlatformType.mobile) ? double.infinity : 360,
          maxHeight: (pType == PlatformType.mobile) ? double.infinity : 482,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              QRCodeWidget(
                service: service,
                logoPath: 'assets/walletconnect_logo_white.png',
              ),
              Visibility(
                visible: (pType == PlatformType.mobile),
                child: GridList(
                  state: GridListState.extraShort,
                  provider: explorerService.instance!,
                  viewLongList: () {
                    widgetStack.instance.add(
                      const WalletListLongPage(),
                    );
                  },
                  onSelect: (WalletData data) {
                    service.connectWallet(
                      walletData: data,
                    );
                  },
                  createListItem: (info, iconSize) {
                    return GridListWalletItem(
                      listItem: info,
                      imageSize: iconSize,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
