import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_modal_flutter/models/launch_url_exception.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils.dart';

import '../mock_classes.mocks.dart';

class MockLaunchUrl extends Mock {
  Future<bool> call(
    Uri? url, {
    LaunchMode? mode = LaunchMode.platformDefault,
  }) =>
      super.noSuchMethod(
        Invocation.method(#call, [url], {#mode: mode}),
        returnValue: Future.value(true),
        returnValueForMissingStub: Future.value(true),
      );
}

class MockCanLaunchUrl extends Mock {
  Future<bool> call(Uri? url) => super.noSuchMethod(
        Invocation.method(#call, [url]),
        returnValue: Future.value(true),
        returnValueForMissingStub: Future.value(true),
      );
}

class MockAndroidAppCheck extends Mock {
  Future<bool> call(String uri) => super.noSuchMethod(
        Invocation.method(#call, [uri]),
        returnValue: Future.value(true),
        returnValueForMissingStub: Future.value(true),
      );
}

void main() {
  group('Url Utils', () {
    final mockLaunchUrl = MockLaunchUrl();
    final mockCanLaunchUrl = MockCanLaunchUrl();
    final mockAndroidAppCheck = MockAndroidAppCheck();
    final mockPlatformUtils = MockPlatformUtils();
    late UrlUtils utils;

    setUp(() {
      utils = UrlUtils(
        androidAppCheck: mockAndroidAppCheck.call,
        launchUrlFunc: mockLaunchUrl.call,
        canLaunchUrlFunc: mockCanLaunchUrl.call,
      );

      platformUtils.instance = mockPlatformUtils;
      when(
        mockPlatformUtils.getPlatformType(),
      ).thenReturn(PlatformType.mobile);
      when(
        mockPlatformUtils.canDetectInstalledApps(),
      ).thenReturn(true);
    });

    group('isInstalled', () {
      test('returns false when URI is null or empty', () async {
        expect(await utils.isInstalled(null), isFalse);
        expect(await utils.isInstalled(''), isFalse);
        expect(await utils.isInstalled('wc://'), isFalse);
      });

      test('returns false when detect installed apps is false', () async {
        when(
          mockPlatformUtils.canDetectInstalledApps(),
        ).thenReturn(false);
        expect(await utils.isInstalled('test'), isFalse);
        verify(
          mockPlatformUtils.canDetectInstalledApps(),
        ).called(1);
      });

      test(
          'isInstalled calls canLaunchUrl/androidAppCheck function when URI is valid',
          () async {
        // canLaunchUrl
        when(
          mockPlatformUtils.getPlatformExact(),
        ).thenReturn(PlatformExact.iOS);
        await utils.isInstalled('https://example.com');
        verify(
          mockPlatformUtils.getPlatformExact(),
        ).called(1);
        verify(
          mockCanLaunchUrl.call(
            Uri.parse('https://example.com'),
          ),
        ).called(1);

        // Android app check
        when(
          mockPlatformUtils.getPlatformExact(),
        ).thenReturn(PlatformExact.android);
        await utils.isInstalled('https://example.com');
        verify(
          mockPlatformUtils.getPlatformExact(),
        ).called(1);
        verify(
          mockAndroidAppCheck.call(
            'https://example.com',
          ),
        ).called(1);
      });
    });

    group('launchRedirect', () {
      test('calls launchUrl function properly', () async {
        // Case 1: Native is not null
        final native = Uri.parse('https://native.com');
        final universal = Uri.parse('https://universal.com');
        await utils.launchRedirect(
          nativeUri: native,
          universalUri: universal,
        );
        verify(
          mockLaunchUrl.call(
            native,
            mode: LaunchMode.externalApplication,
          ),
        ).called(1);

        // Case 2: Native is null, universal is not null
        await utils.launchRedirect(
          nativeUri: null,
          universalUri: universal,
        );
        verify(
          mockLaunchUrl.call(
            universal,
            mode: LaunchMode.externalApplication,
          ),
        ).called(1);

        // Case 3: Native is invalid, universal is not null
        when(mockLaunchUrl.call(native, mode: anyNamed('mode'))).thenThrow(
          Exception('Unable to launch'),
        );
        await utils.launchRedirect(
          nativeUri: native,
          universalUri: universal,
        );
        verify(
          mockLaunchUrl.call(
            native,
            mode: LaunchMode.externalApplication,
          ),
        ).called(1);
        verify(
          mockLaunchUrl.call(
            universal,
            mode: LaunchMode.externalApplication,
          ),
        ).called(1);
      });

      test(
          'throws LaunchUrlException when nativeUri and universalUri are null or invalid',
          () async {
        final native = Uri.parse('https://universal.com');
        final universal = Uri.parse('https://universal.com');
        // when(mockCanLaunchUrl.call(any)).thenAnswer((_) => Future.value(false));

        // Case 1: Both null
        try {
          await utils.launchRedirect(
            nativeUri: null,
            universalUri: null,
          );
        } catch (e) {
          expect(e, isA<LaunchUrlException>());
          expect(
            (e as LaunchUrlException).message,
            'Unable to open the wallet',
          );
          verifyNever(mockLaunchUrl.call(
            any,
            mode: anyNamed('mode'),
          ));
        }

        // Case 2: native null, universal invalid
        when(mockLaunchUrl.call(universal, mode: anyNamed('mode'))).thenThrow(
          Exception('Unable to launch'),
        );
        try {
          await utils.launchRedirect(
            nativeUri: null,
            universalUri: universal,
          );
        } catch (e) {
          expect(e, isA<LaunchUrlException>());
          expect(
            (e as LaunchUrlException).message,
            'Unable to open the wallet',
          );
          verify(mockLaunchUrl.call(
            any,
            mode: anyNamed('mode'),
          )).called(1);
        }

        // Case 3: native invalid, universal null
        when(mockLaunchUrl.call(native, mode: anyNamed('mode'))).thenThrow(
          Exception('Unable to launch'),
        );
        try {
          await utils.launchRedirect(
            nativeUri: native,
            universalUri: null,
          );
        } catch (e) {
          expect(e, isA<LaunchUrlException>());
          expect(
            (e as LaunchUrlException).message,
            'Unable to open the wallet',
          );
          verify(mockLaunchUrl.call(
            any,
            mode: anyNamed('mode'),
          )).called(1);
        }

        // Case 4: native invalid, universal invalid
        try {
          await utils.launchRedirect(
            nativeUri: native,
            universalUri: universal,
          );
        } catch (e) {
          expect(e, isA<LaunchUrlException>());
          expect(
            (e as LaunchUrlException).message,
            'Unable to open the wallet',
          );
          verify(mockLaunchUrl.call(
            any,
            mode: anyNamed('mode'),
          )).called(2);
        }
      });
    });

    test('navigateDeepLink calls launchRedirect function when links are valid',
        () async {
      when(mockLaunchUrl.call(
        Uri.parse('https://native.com'),
        mode: anyNamed('mode'),
      )).thenAnswer((_) => Future.value(true));

      await utils.navigateDeepLink(
        nativeLink: 'https://native.com',
        universalLink: 'https://universal.com',
        wcURI: 'https://wc.com',
      );
      verify(
        mockLaunchUrl.call(
          any,
          mode: anyNamed('mode'),
        ),
      ).called(1);
    });
  });
}
