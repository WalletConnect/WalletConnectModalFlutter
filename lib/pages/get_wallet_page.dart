import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_button.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_item_model.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_provider.dart';
import 'package:walletconnect_modal_flutter/widgets/wallet_image.dart';

class GetWalletPage extends StatelessWidget {
  const GetWalletPage({
    super.key,
    required this.service,
  });

  final GridListProvider<WalletData> service;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    List<GridListItemModel<WalletData>> wallets = service.itemList.value
        .where((GridListItemModel<WalletData> w) => !w.data.installed)
        .take(6)
        .toList();

    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children:
              wallets.map((wallet) => WalletItem(wallet: wallet)).toList(),
        ),
        const SizedBox(height: 8.0),
        Text(
          "Not what you're looking for?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: themeData.foreground100,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          "With hundreds of wallets out there, there's something for everyone",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: themeData.foreground200,
          ),
        ),
        const SizedBox(height: 8.0),
        WalletConnectModalButton(
          onPressed: () => urlUtils.instance.launchUrl(
            Uri.parse(
              StringConstants.getAWalletExploreWalletsUrl,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Explore Wallets',
                style: TextStyle(
                  fontFamily: themeData.fontFamily,
                  color: themeData.inverse100,
                ),
              ),
              Icon(
                Icons.arrow_outward,
                size: 12,
                color: themeData.inverse100,
              ),
            ],
          ),
        ),
        // URL: https://explorer.walletconnect.com/?type=wallet
      ],
    );
  }
}

class WalletItem extends StatelessWidget {
  const WalletItem({
    super.key,
    required this.wallet,
  });

  final GridListItemModel<WalletData> wallet;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 200,
      ),
      padding: const EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
      ),
      child: ListTile(
        leading: WalletImage(
          imageUrl: wallet.image,
          imageSize: 50,
        ),
        title: Text(
          wallet.title,
          style: TextStyle(
            fontSize: 16.0,
            color: themeData.foreground100,
          ),
        ),
        trailing: WalletConnectModalButton(
          onPressed: () => urlUtils.instance.launchUrl(
            Uri.parse(
              wallet.data.listing.homepage,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Get',
                style: TextStyle(
                  fontFamily: themeData.fontFamily,
                  color: themeData.inverse100,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: themeData.inverse100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
