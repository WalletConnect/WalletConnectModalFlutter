import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({
    super.key,
    required this.service,
    required this.logoPath,
  });

  final IWalletConnectModalService service;
  final String logoPath;

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  bool _initialized = false;
  String _qrCode = '';

  @override
  void initState() {
    super.initState();
    // _qrCode = widget.service.wcUri!;

    _initialize();

    // widget.service.addListener(_qrCodeChanged);
  }

  Future<void> _initialize() async {
    if (_initialized) {
      return;
    }

    await widget.service.rebuildConnectionUri();

    setState(() {
      _qrCode = widget.service.wcUri!;
      _initialized = true;
    });
  }

  // @override
  // void dispose() {
  //   widget.service.removeListener(_qrCodeChanged);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
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
              color: WalletConnectModalTheme.getData(context).primary100,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          WalletConnectModalTheme.getData(context).radiusXS,
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
          // embeddedImage: Image.asset(
          //   'assets/walletconnect_logo_white.png',
          //   package: 'walletconnect_modal_flutter',
          // ).image,
          // embeddedImageStyle: QrEmbeddedImageStyle(
          //   size: const Size(120, 120),
          //   color: Web3ModalTheme.of(context).backgroundColor,
          // ),
        ),
      ),
    );
  }
}
