import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/pages/qr_code_page.dart';
import 'package:walletconnect_modal_flutter/pages/wallet_list_long_page.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_wallet_item.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_icon_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar_title.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';

class WalletListShortPage extends StatelessWidget {
  const WalletListShortPage()
      : super(
          key: WalletConnectModalConstants.walletListShortPageKey,
        );

  @override
  Widget build(BuildContext context) {
    final IWalletConnectModalService service =
        WalletConnectModalProvider.of(context).service;

    return WalletConnectModalNavBar(
      title: const WalletConnectModalNavbarTitle(
        title: 'Connect your wallet',
      ),
      actionWidget: WalletConnectIconButton(
        iconPath: 'assets/icons/qr_code.svg',
        onPressed: () {
          widgetStack.instance.add(
            const QRCodePage(),
          );
        },
      ),
      child: GridList<WalletData>(
        state: GridListState.short,
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
    );
  }
}
