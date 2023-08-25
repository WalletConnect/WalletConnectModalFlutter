import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModalToast extends StatefulWidget {
  const WalletConnectModalToast({
    super.key,
    required this.message,
  });

  final ToastMessage message;

  @override
  State<WalletConnectModalToast> createState() =>
      _WalletConnectModalToastState();
}

class _WalletConnectModalToastState extends State<WalletConnectModalToast>
    with SingleTickerProviderStateMixin {
  static const fadeInTime = 200;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: fadeInTime),
      vsync: this,
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward().then((_) {
      Future.delayed(
        widget.message.duration -
            const Duration(
              milliseconds: fadeInTime * 2,
            ),
      ).then((_) {
        if (!mounted) {
          return;
        }
        _controller.reverse().then(
              (value) => toastUtils.instance.clear(),
            );
        // .then(
        //   () async {
        //     widget.message.completer.complete();
        //   },
        // );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);

    return Positioned(
      top: 10.0,
      left: 20.0,
      right: 20.0,
      child: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: themeData.background300,
              borderRadius: BorderRadius.circular(
                themeData.radiusM,
              ),
              border: Border.all(
                color: themeData.overlay005,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    widget.message.type == ToastType.info
                        ? 'assets/icons/checkmark.svg'
                        : 'assets/icons/error.svg',
                    width: 16,
                    height: 16,
                    package: 'walletconnect_modal_flutter',
                    colorFilter: ColorFilter.mode(
                      themeData.primary100,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    widget.message.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeData.foreground100,
                      fontWeight: FontWeight.w600,
                      fontFamily: themeData.fontFamily,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
