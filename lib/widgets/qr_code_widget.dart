import 'dart:math';

import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({
    super.key,
    required this.service,
    required this.logoPath,
  });

  final IWalletConnectModalService service;
  final String logoPath;

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  bool _initialized = false;
  String _qrCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.service.addListener(_rebuild);
      widget.service.onPairingExpireEvent.subscribe(_onPairingExpire);
      await widget.service.rebuildConnectionUri();
      _rebuild();
    });
  }

  void _onPairingExpire(EventArgs? args) async {
    await widget.service.rebuildConnectionUri();
  }

  @override
  void dispose() {
    widget.service.onPairingExpireEvent.unsubscribe(_onPairingExpire);
    widget.service.removeListener(_rebuild);
    widget.service.clearPreviousInactivePairings();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      _qrCode = widget.service.wcUri!;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = WalletConnectModalTheme.getData(context);

    bool isLongBottomSheet = platformUtils.instance.isLongBottomSheet(
      MediaQuery.of(context).orientation,
    );
    double qrSize = MediaQuery.of(context).size.height - 200;
    double marginAndPadding = isLongBottomSheet ? 1.0 : 8.0;

    if (!_initialized) {
      double size = min(
            qrSize,
            MediaQuery.of(context).size.width,
          ) -
          marginAndPadding * 2;
      return Container(
        width: size,
        height: size,
        margin: EdgeInsets.all(marginAndPadding),
        padding: EdgeInsets.all(marginAndPadding),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          themeData.radiusL,
        ),
      ),
      constraints: isLongBottomSheet
          ? BoxConstraints(
              maxHeight: qrSize,
              maxWidth: qrSize,
            )
          : null,
      margin: EdgeInsets.all(marginAndPadding),
      padding: EdgeInsets.all(marginAndPadding),
      child: Center(
        child: QrImageView(
          data: _qrCode,
          version: QrVersions.auto,
          // size: 300.0,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.circle,
            color: Colors.black,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: Colors.black,
          ),
          // gapless: true,
          // embeddedImage: const AssetImage(
          //   'assets/walletconnect_logo_blue_solid_background.png',
          //   package: 'walletconnect_modal_flutter',
          //   // color: themeData.primary100,
          // ),
          // embeddedImageStyle: const QrEmbeddedImageStyle(
          //   size: Size(80, 80),
          //   // color: themeData.primary100,
          // ),
          embeddedImageEmitsError: true,
        ),
      ),
    );
  }
}
