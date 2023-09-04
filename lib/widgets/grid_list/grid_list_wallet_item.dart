import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_item_model.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class GridListWalletItem extends StatelessWidget {
  const GridListWalletItem({
    super.key,
    required this.listItem,
    this.imageSize = GridList.tileSize,
  });

  final GridListItemModel listItem;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: imageSize,
          height: imageSize,
          // margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              GridList.getTileBorderRadius(imageSize),
            ),
            border: Border.all(
              color: themeData.overlay010,
              width: 1.0,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            listItem.image,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          listItem.title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: 12.0,
            color: themeData.foreground100,
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          listItem.description ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: 12.0,
            color: themeData.foreground300,
          ),
        ),
      ],
    );
  }
}
