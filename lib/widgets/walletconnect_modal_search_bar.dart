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
      height: 30,
      decoration: BoxDecoration(
        color: themeData.overlay005,
        borderRadius: BorderRadius.circular(
          themeData.radiusXS,
        ),
      ),
      child: TextFormField(
        onChanged: onSearch,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: themeData.inverse100,
        ),
        cursorColor: themeData.primary100,
        cursorHeight: 20,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: themeData.foreground275,
          ),
          labelStyle: TextStyle(
            color: themeData.inverse000,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: themeData.foreground275,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeData.overlay005,
            ),
            borderRadius: BorderRadius.circular(
              100,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeData.primary100,
            ),
            borderRadius: BorderRadius.circular(
              100,
            ),
          ),
          // contentPadding: const EdgeInsets.symmetric(
          //   vertical: 0,
          //   horizontal: 10,
          // ),
          isCollapsed: true,
          // contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
        ),
      ),
    );
  }
}
