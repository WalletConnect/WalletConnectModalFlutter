import 'package:walletconnect_flutter_v2/apis/core/relay_client/relay_client.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service.dart';
import 'package:walletconnect_modal_flutter/services/storage_service/storage_service.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  ExplorerService,
  WalletConnectModalService,
  UrlUtils,
  PlatformUtils,
  ToastUtils,
  Web3App,
  Sessions,
  RelayClient,
  StorageService,
  http.Client,
])
class Mocks {}
