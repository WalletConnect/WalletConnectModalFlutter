import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({
    super.key,
    required this.qrData,
    required this.logoPath,
  });

  final String qrData;
  final String logoPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          WalletConnectModalTheme.getData(context).radiusXS,
        ),
      ),
      child: Center(
        child: QrImageView(
          data: qrData,
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
