import 'package:flutter/foundation.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/i_url_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_web.dart';

class UrlUtilsSingleton {
  IUrlUtils instance;

  UrlUtilsSingleton() : instance = kIsWeb ? UrlUtilsWeb() : UrlUtils();
}

final urlUtils = UrlUtilsSingleton();
