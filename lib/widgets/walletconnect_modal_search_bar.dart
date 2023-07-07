import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModalSearchBar extends StatelessWidget {
  const WalletConnectModalSearchBar({
    super.key,
    required this.hintText,
    required this.onSearch,
  });

  final String hintText;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: themeData.overlay005,
        borderRadius: BorderRadius.circular(
          themeData.radiusXS,
        ),
        border: Border.all(
          color: themeData.overlay005,
          width: 2,
        ),
      ),
      child: TextFormField(
        onChanged: onSearch,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: themeData.foreground275,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: themeData.foreground275,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: themeData.foreground275,
          ),
          border: InputBorder.none,
          isCollapsed: true,
          // contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
        ),
      ),
    );
  }
}
