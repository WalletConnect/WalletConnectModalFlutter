import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class GridListItem extends StatelessWidget {
  const GridListItem({
    super.key,
    required this.title,
    required this.onSelect,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final void Function() onSelect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            child,
            const SizedBox(height: 4.0),
            Text(
              title,
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
              description ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 12.0,
                color: themeData.foreground300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
