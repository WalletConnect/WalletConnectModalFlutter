import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_search_bar.dart';

class WalletListLongPage extends StatelessWidget {
  const WalletListLongPage()
      : super(
          key: WalletConnectModalConstants.walletListLongPageKey,
        );

  @override
  Widget build(BuildContext context) {
    final IWalletConnectModalService service =
        WalletConnectModalProvider.of(context).service;

    return WalletConnectModalNavBar(
      title: WalletConnectModalSearchBar(
        hintText: 'Search wallets',
        onSearch: (String query) {
          explorerService.instance!.filterList(
            query: query,
          );
        },
      ),
      onBack: () {
        // When we leave this page, we want to reset the list to its original state
        explorerService.instance!.filterList(
          query: null,
        );
      },
      child: GridList<WalletData>(
        state: GridListState.long,
        provider: explorerService.instance!,
        onSelect: (WalletData data) {
          service.connectWallet(
            walletData: data,
          );
        },
      ),
    );
  }
}
