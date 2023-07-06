import 'dart:collection';
import 'package:w_common/disposable.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/i_toast_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'dart:async';

class ToastUtils extends IToastUtils with Disposable {
  final _toastController = StreamController<ToastMessage?>.broadcast();

  final _queue = Queue<ToastMessageCompleter>();

  bool _isShowing = false;

  @override
  Stream<ToastMessage?> get toasts => _toastController.stream;

  @override
  Future<void> show(ToastMessage message) async {
    final completer = ToastMessageCompleter(message);

    _queue.add(completer);

    if (!_isShowing) {
      _popToast();
    }

    await completer.completer.future;
  }

  Future<void> _popToast() async {
    if (_queue.isNotEmpty) {
      _isShowing = true;
      final messageCompleter = _queue.removeFirst();
      _toastController.add(messageCompleter.message);
      await Future.delayed(messageCompleter.message.duration * 2);
      messageCompleter.completer.complete();
      _isShowing = false;
      _popToast();
    } else {
      _isShowing = false;
      _toastController.add(null);
    }
  }

  @override
  // ignore: prefer_void_to_null
  Future<Null> onDispose() async {
    _toastController.close();
  }
}
