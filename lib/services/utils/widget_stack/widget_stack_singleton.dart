import 'package:walletconnect_modal_flutter/services/utils/widget_stack/i_widget_stack.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack.dart';

class WidgetStackSingleton {
  IWidgetStack instance;

  WidgetStackSingleton() : instance = WidgetStack();
}

final widgetStack = WidgetStackSingleton();
