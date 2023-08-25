import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/explorer/i_explorer_service.dart';
import 'package:walletconnect_modal_flutter/services/storage_service/i_storage_service.dart';
import 'package:walletconnect_modal_flutter/services/storage_service/storage_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/core/core_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/core/i_core_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/i_toast_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/i_url_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/i_widget_stack.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';

class WalletConnectModalServices {
  static IExplorerService get explorer => explorerService.instance!;
  static ICoreUtils get core => coreUtils.instance;
  static IToastUtils get toast => toastUtils.instance;
  static IUrlUtils get url => urlUtils.instance;
  static IWidgetStack get stack => widgetStack.instance;
  static IPlatformUtils get platform => platformUtils.instance;
  static IStorageService get storage => storageService.instance;

  static final Map<String, Function> _initFunctions = {};

  /// Register a function to be called during [init], which is called when a WalletConnectModalService
  /// or any inherited version of it is created.
  static void registerInitFunction(String name, Function function) {
    _initFunctions[name] = function;
  }

  // static final Map<Type, Future> initFunctionsMap = {};

  static Future<void> init() async {
    LoggerUtil.logger.i('WalletConnectModalServices init');
    await explorer.init();
    for (final entry in _initFunctions.entries) {
      LoggerUtil.logger
          .v('WalletConnectModalServices init service: ${entry.key}');
      await entry.value();
    }
  }
}
