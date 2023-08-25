import 'dart:math';

import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_item.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_item_model.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_provider.dart';
import 'package:walletconnect_modal_flutter/widgets/wallet_image.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

enum GridListState { short, long, extraShort }

class GridList<T> extends StatelessWidget {
  static const double tileSize = 60;
  static double getTileBorderRadius(double tileSize) => tileSize / 4.0;

  const GridList({
    super.key,
    this.state = GridListState.short,
    required this.provider,
    this.viewLongList,
    required this.onSelect,
  });

  final GridListState state;
  final GridListProvider<T> provider;
  final void Function()? viewLongList;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return ValueListenableBuilder(
      valueListenable: provider.initialized,
      builder: (context, bool value, child) {
        if (value) {
          return _buildGridList(context);
        } else {
          return Container(
            padding: const EdgeInsets.all(8.0),
            height: 240,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: themeData.primary100,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildGridList(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    final bool longBottomSheet = platformUtils.instance.isLongBottomSheet(
      MediaQuery.of(context).orientation,
    );

    return ValueListenableBuilder(
      valueListenable: provider.itemList,
      builder: (context, List<GridListItemModel<T>> value, child) {
        int itemCount;
        double height;
        switch (state) {
          case GridListState.short:
            itemCount = min(8, value.length);
            height = longBottomSheet ? 120 : 240;
            break;
          case GridListState.long:
            itemCount = value.length;
            height = longBottomSheet ? 240 : 600;
            break;
          case GridListState.extraShort:
            itemCount = min(4, value.length);
            height = 120;
            break;
        }

        if (value.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            height: height,
            child: Center(
              child: Text(
                StringConstants.noResults,
                style: TextStyle(
                  color: themeData.foreground200,
                  fontFamily: themeData.fontFamily,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(8.0),
          height: height,
          child: GridView.builder(
            key: Key('${value.length}'),
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: longBottomSheet ? 8 : 4,
              childAspectRatio: longBottomSheet ? 0.73 : 0.85,
            ),
            itemBuilder: (context, index) {
              if (index == itemCount - 1 &&
                  value.length > itemCount &&
                  state != GridListState.long) {
                return _buildViewAll(
                  context,
                  value,
                  itemCount,
                );
              } else {
                return GridListItem(
                  key: Key(value[index].title),
                  title: value[index].title,
                  description: value[index].description,
                  onSelect: () => onSelect(value[index].data),
                  child: WalletImage(
                    imageUrl: value[index].image,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildViewAll(
    BuildContext context,
    List<GridListItemModel<T>> items,
    int startIndex,
  ) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    List<Widget> images = [];

    for (int i = 0; i < 4; i++) {
      if (startIndex + i + 1 > items.length) {
        break;
      }

      images.add(
        WalletImage(
          imageUrl: items[startIndex + i].image,
          imageSize: GridList.tileSize / 3.0,
        ),
      );
    }

    return GridListItem(
      key: WalletConnectModalConstants.gridListViewAllButtonKey,
      title: 'View All',
      onSelect: viewLongList ?? () {},
      child: Container(
        width: GridList.tileSize,
        height: GridList.tileSize,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: themeData.background200,
          border: Border.all(
            color: themeData.overlay010,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(
            GridList.getTileBorderRadius(GridList.tileSize),
          ),
        ),
        child: Center(
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: images,
          ),
        ),
      ),
    );
  }
}
