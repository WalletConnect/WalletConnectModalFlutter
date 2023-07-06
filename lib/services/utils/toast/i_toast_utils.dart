import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'dart:async';

class ToastMessageCompleter {
  final ToastMessage message;
  final Completer completer = Completer();

  ToastMessageCompleter(this.message);
}

abstract class IToastUtils {
  Stream<ToastMessage?> get toasts;

  Future<void> show(ToastMessage message);
}
