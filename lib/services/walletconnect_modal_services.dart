import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/explorer/i_explorer_service.dart';
import 'package:walletconnect_modal_flutter/services/utils/core/core_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/core/i_core_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/i_toast_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/i_url_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/i_widget_stack.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';

class WalletConnectModalServices {
  IExplorerService get explorer => explorerService.instance!;
  ICoreUtils get core => coreUtils.instance;
  IToastUtils get toast => toastUtils.instance;
  IUrlUtils get url => urlUtils.instance;
  IWidgetStack get stack => widgetStack.instance;
  IPlatformUtils get platform => platformUtils.instance;
}
