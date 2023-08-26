import 'package:appcheck/appcheck.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_modal_flutter/models/launch_url_exception.dart';
import 'package:walletconnect_modal_flutter/services/utils/core/core_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/i_url_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';

Future<bool> _launchUrl(Uri url, {LaunchMode? mode}) async {
  try {
    return await launchUrl(
      url,
      mode: mode ?? LaunchMode.platformDefault,
    );
  } catch (e) {
    LoggerUtil.logger.e(
      'Error launching URL: ${url.toString()}',
    );
    LoggerUtil.logger.e(e);
    throw LaunchUrlException(
      'Error launching URL: ${url.toString()}',
    );
  }
}

Future<bool> _androidLaunch(String uri) async {
  return await AppCheck.isAppEnabled(uri);
}

class UrlUtils extends IUrlUtils {
  UrlUtils({
    this.androidAppCheck = _androidLaunch,
    this.launchUrlFunc = _launchUrl,
    this.canLaunchUrlFunc = canLaunchUrl,
  });

  final Future<bool> Function(String uri) androidAppCheck;
  final Future<bool> Function(Uri url, {LaunchMode? mode}) launchUrlFunc;
  final Future<bool> Function(Uri url) canLaunchUrlFunc;

  @override
  Future<bool> isInstalled(String? uri) async {
    if (uri == null || uri.isEmpty) {
      return false;
    }

    // If the wallet is just a generic wc:// then it is not installed
    if (uri.contains('wc://')) {
      return false;
    }

    if (platformUtils.instance.canDetectInstalledApps()) {
      final PlatformExact p = platformUtils.instance.getPlatformExact();
      try {
        if (p == PlatformExact.android) {
          return await androidAppCheck(uri);
        } else if (p == PlatformExact.iOS) {
          await canLaunchUrlFunc(
            Uri.parse(
              uri,
            ),
          );
        }
      } catch (_) {
        // print(e);
      }
    }

    return false;
  }

  @override
  Future<bool> launchUrl(
    Uri url, {
    LaunchMode? mode,
  }) async {
    return launchUrlFunc(
      url,
      mode: mode,
    );
  }

  @override
  Future<void> launchRedirect({
    Uri? nativeUri,
    Uri? universalUri,
  }) async {
    LoggerUtil.logger.i(
      'Navigating deep links. Native: ${nativeUri.toString()}, Universal: ${universalUri.toString()}',
    );
    LoggerUtil.logger.v(
      'Deep Link Query Params. Native: ${nativeUri?.queryParameters}, Universal: ${universalUri?.queryParameters}',
    );

    try {
      // Launch the link
      if (nativeUri != null) {
        LoggerUtil.logger.i(
          'Navigating deep links. Launching native URI.',
        );
        try {
          final bool launched = await launchUrlFunc(
            nativeUri,
            mode: LaunchMode.externalApplication,
          );
          if (!launched) {
            throw Exception('Unable to launch native URI');
          }
        } catch (e) {
          LoggerUtil.logger.i(
            'Navigating deep links. Launching native failed, launching universal URI.',
          );
          // Fallback to universal link
          if (universalUri != null) {
            final bool launched = await launchUrlFunc(
              universalUri,
              mode: LaunchMode.externalApplication,
            );
            if (!launched) {
              throw Exception('Unable to launch native URI');
            }
          } else {
            throw LaunchUrlException('Unable to open the wallet');
          }
        }
      } else if (universalUri != null) {
        LoggerUtil.logger.v(
          'Navigating deep links. Launching universal URI.',
        );
        final bool launched = await launchUrlFunc(
          universalUri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          throw Exception('Unable to launch native URI');
        }
      } else {
        throw LaunchUrlException('Unable to open the wallet');
      }
    } catch (e) {
      throw LaunchUrlException('Unable to open the wallet');
    }
  }

  @override
  Future<void> navigateDeepLink({
    String? nativeLink,
    String? universalLink,
    required String wcURI,
  }) async {
    // Construct the link
    final Uri? nativeUri = coreUtils.instance.formatNativeUrl(
      nativeLink,
      wcURI,
    );
    final Uri? universalUri = coreUtils.instance.formatUniversalUrl(
      universalLink,
      wcURI,
    );

    await launchRedirect(
      nativeUri: nativeUri,
      universalUri: universalUri,
    );
  }
}
