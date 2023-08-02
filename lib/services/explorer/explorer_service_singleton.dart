import 'package:walletconnect_modal_flutter/services/explorer/i_explorer_service.dart';

class ExplorerServiceSingleton {
  IExplorerService? instance;
}

final explorerService = ExplorerServiceSingleton();
