import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

enum WalletConnectModalConnectButtonState {
  error,
  idle,
  connecting,
  connected,
}

class WalletConnectModalConnect extends StatefulWidget {
  const WalletConnectModalConnect({
    super.key,
    required this.service,
    this.buttonRadius,
    this.connectedWidget,
  });

  final IWalletConnectModalService service;
  final double? buttonRadius;
  final Widget? connectedWidget;

  @override
  State<WalletConnectModalConnect> createState() =>
      _WalletConnectModalConnectState();
}

class _WalletConnectModalConnectState extends State<WalletConnectModalConnect> {
  WalletConnectModalConnectButtonState _state =
      WalletConnectModalConnectButtonState.idle;

  @override
  void initState() {
    super.initState();

    _updateState();

    widget.service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    super.dispose();

    widget.service.removeListener(_onServiceUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    if (_state == WalletConnectModalConnectButtonState.error) {
      return WalletConnectModalButton(
        borderRadius: widget.buttonRadius ?? themeData.radius4XS,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringConstants.connectButtonError,
              style: TextStyle(
                color: themeData.error,
                fontFamily: themeData.fontFamily,
              ),
            ),
          ],
        ),
      );
    } else if (_state == WalletConnectModalConnectButtonState.idle) {
      return WalletConnectModalButton(
        borderRadius: widget.buttonRadius ?? themeData.radius4XS,
        onPressed: () => _onConnectPressed(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/walletconnect_logo_white.svg',
              width: 20,
              height: 20,
              package: 'walletconnect_modal_flutter',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              StringConstants.connectButtonIdle,
              style: TextStyle(
                color: Colors.white,
                fontFamily: themeData.fontFamily,
              ),
            ),
          ],
        ),
      );
    } else if (_state == WalletConnectModalConnectButtonState.connecting) {
      return WalletConnectModalButton(
        borderRadius: widget.buttonRadius ?? themeData.radius4XS,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: Center(
                child: CircularProgressIndicator(
                  color: themeData.primary100,
                  strokeWidth: 4,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              StringConstants.connectButtonConnecting,
              style: TextStyle(
                color: themeData.primary100,
                fontFamily: themeData.fontFamily,
              ),
            ),
          ],
        ),
      );
    } else if (_state == WalletConnectModalConnectButtonState.connected) {
      // Allow handling a custom connected widget
      if (widget.connectedWidget != null) {
        return widget.connectedWidget!;
      } else {
        // Default to a disconnect button
        return WalletConnectModalButton(
          borderRadius: widget.buttonRadius ?? themeData.radius4XS,
          onPressed: () => _onConnectPressed(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringConstants.connectButtonConnected,
                style: TextStyle(
                  color: themeData.foreground100,
                  fontFamily: themeData.fontFamily,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Container();
  }

  void _onConnectPressed(BuildContext context) {
    if (widget.service.isConnected) {
      widget.service.disconnect();
    } else {
      widget.service.open(context: context);
    }
  }

  void _onServiceUpdate() {
    LoggerUtil.logger.i(
      'Web3ModalConnectButton._onServiceUpdate(). isConnected: ${widget.service.isConnected}, isOpen: ${widget.service.isOpen}',
    );

    _updateState();
  }

  void _updateState() {
    // Case 0: init error
    if (widget.service.initError != null) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.error;
      });
      return;
    }
    // Case 1: Is connected
    else if (widget.service.isConnected) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.connected;
      });
      return;
    }
    // Case 2: Is not open and is not connected
    else if (!widget.service.isOpen && !widget.service.isConnected) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.idle;
      });
      return;
    }
    // Case 3: Is open and is not connected
    else if (widget.service.isOpen && !widget.service.isConnected) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.connecting;
      });
      return;
    }
  }
}
