import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

enum WalletConnectModalConnectButtonState {
  idle,
  connecting,
  account,
}

class WalletConnectModalConnect extends StatefulWidget {
  const WalletConnectModalConnect({
    super.key,
    required this.walletConnectModalService,
    this.buttonRadius,
  });

  final IWalletConnectModalService walletConnectModalService;
  final double? buttonRadius;

  @override
  State<WalletConnectModalConnect> createState() =>
      _WalletConnectModalConnectState();
}

class _WalletConnectModalConnectState extends State<WalletConnectModalConnect> {
  static const double buttonHeight = 60;
  static const double buttonWidthMin = 150;
  static const double buttonWidthMax = 200;

  WalletConnectModalConnectButtonState _state =
      WalletConnectModalConnectButtonState.idle;

  @override
  void initState() {
    super.initState();

    _updateState();

    widget.walletConnectModalService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    super.dispose();

    widget.walletConnectModalService.removeListener(_onServiceUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: buttonHeight,
        minWidth: buttonWidthMin,
        maxWidth: buttonWidthMax,
      ),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final WalletConnectModalTheme theme = WalletConnectModalTheme.of(context);

    if (_state == WalletConnectModalConnectButtonState.idle) {
      return MaterialButton(
        onPressed: () => _onConnectPressed(context),
        color: theme.data.primary100,
        focusColor: theme.data.primary090,
        hoverColor: theme.data.primary090,
        highlightColor: theme.data.primary080,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.buttonRadius ?? theme.data.radius4XS,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/walletconnect_logo_white.svg',
              width: 20,
              height: 20,
              package: 'walletconnect_modal_flutter',
              colorFilter: ColorFilter.mode(
                theme.data.foreground100,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              'Connect Wallet',
              style: TextStyle(
                color: theme.data.foreground100,
                fontFamily: theme.data.fontFamily,
              ),
            ),
          ],
        ),
      );
    } else if (_state == WalletConnectModalConnectButtonState.connecting) {
      return MaterialButton(
        onPressed: () {},
        color: theme.data.overlay030,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.buttonRadius ?? theme.data.radius4XS,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: theme.data.primary100,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Connecting...',
              style: TextStyle(
                color: theme.data.foreground100,
                fontFamily: theme.data.fontFamily,
              ),
            ),
          ],
        ),
      );
    } else if (_state == WalletConnectModalConnectButtonState.account) {
      return MaterialButton(
        onPressed: () => _onConnectPressed(context),
        color: theme.data.primary100,
        focusColor: theme.data.primary090,
        hoverColor: theme.data.primary090,
        highlightColor: theme.data.primary080,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.buttonRadius ?? theme.data.radius4XS,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Disconnect',
              style: TextStyle(
                color: theme.data.foreground100,
                fontFamily: theme.data.fontFamily,
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  void _onConnectPressed(BuildContext context) {
    if (widget.walletConnectModalService.isConnected) {
      widget.walletConnectModalService.disconnect();
    } else {
      widget.walletConnectModalService.open(context: context);
    }
  }

  void _onServiceUpdate() {
    LoggerUtil.logger.i(
      'Web3ModalConnectButton._onServiceUpdate(). isConnected: ${widget.walletConnectModalService.isConnected}, isOpen: ${widget.walletConnectModalService.isOpen}',
    );

    _updateState();
  }

  void _updateState() {
    // Case 1: Is connected
    if (widget.walletConnectModalService.isConnected) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.account;
      });
      return;
    }
    // Case 2: Is not open and is not connected
    else if (!widget.walletConnectModalService.isOpen &&
        !widget.walletConnectModalService.isConnected) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.idle;
      });
      return;
    }
    // Case 3: Is open and is not connected
    else if (widget.walletConnectModalService.isOpen &&
        !widget.walletConnectModalService.isConnected) {
      setState(() {
        _state = WalletConnectModalConnectButtonState.connecting;
      });
      return;
    }
  }
}
