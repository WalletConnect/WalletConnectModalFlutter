import 'package:walletconnect_modal_flutter/services/utils/toast/i_toast_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils.dart';

class ToastUtilsSingleton {
  IToastUtils instance;

  ToastUtilsSingleton() : instance = ToastUtils();
}

final toastUtils = ToastUtilsSingleton();
