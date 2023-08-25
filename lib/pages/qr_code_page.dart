import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/qr_code_widget.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_icon_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar_title.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage()
      : super(
          key: WalletConnectModalConstants.qrCodePageKey,
        );

  @override
  Widget build(BuildContext context) {
    final IWalletConnectModalService service =
        WalletConnectModalProvider.of(context).service;

    return WalletConnectModalNavBar(
      title: const WalletConnectModalNavbarTitle(
        title: 'Scan the code',
      ),
      actionWidget: WalletConnectIconButton(
        iconPath: 'assets/icons/copy.svg',
        onPressed: () {
          _copyQrCodeToClipboard(context);
        },
      ),
      child: QRCodeWidget(
        service: service,
        logoPath: 'assets/walletconnect_logo_white.png',
      ),
    );
  }

  Future<void> _copyQrCodeToClipboard(BuildContext context) async {
    final IWalletConnectModalService service =
        WalletConnectModalProvider.of(context).service;
    await Clipboard.setData(
      ClipboardData(
        text: service.wcUri!,
      ),
    );
    toastUtils.instance.show(
      ToastMessage(
        type: ToastType.info,
        text: 'Link copied',
      ),
    );
  }
}
