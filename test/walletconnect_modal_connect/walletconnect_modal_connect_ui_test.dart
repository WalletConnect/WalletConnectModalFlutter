import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

import '../mock_classes.mocks.dart';

class WalletConnectModalServiceSpy extends MockWalletConnectModalService {
  final List<VoidCallback> _listeners = [];

  @override
  void addListener(VoidCallback? listener) {
    if (listener != null) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(VoidCallback? listener) {
    _listeners.remove(listener);
  }

  @override
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletConnectModalService', () {
    late WalletConnectModalServiceSpy service;

    setUp(() async {
      service = WalletConnectModalServiceSpy();
      when(service.initError).thenReturn(null);
      when(service.isConnected).thenReturn(false);
      when(service.isOpen).thenReturn(false);
      when(service.requiredNamespaces).thenReturn(
        {'1': const RequiredNamespace(methods: [], events: [])},
      );
    });

    testWidgets('should open or disconnect on tap',
        (WidgetTester tester) async {
      // FlutterError.onError = ignoreOverflowErrors;

      final GlobalKey key = GlobalKey();
      // late BuildContext context;

      // Build our app and trigger a frame.
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 100,
              child: Builder(
                builder: (context) {
                  return WalletConnectModalConnect(
                    key: key,
                    service: service,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // idle state
      expect(
        find.text(
          StringConstants.connectButtonIdle,
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(key));
      await tester.pump();

      verify(
        service.open(context: anyNamed('context')),
      ).called(1);

      // Connecting state
      when(service.isConnected).thenReturn(false);
      when(service.isOpen).thenReturn(true);
      service.notifyListeners();

      await tester.pump();

      expect(
        find.text(
          StringConstants.connectButtonConnecting,
          skipOffstage: false,
        ),
        findsOneWidget,
      );

      when(service.isConnected).thenReturn(true);
      when(service.isOpen).thenReturn(true);
      service.notifyListeners();

      await tester.pumpAndSettle();

      expect(
        find.text(StringConstants.connectButtonConnected),
        findsOneWidget,
      );

      // Disconnect flow
      await tester.tap(find.byKey(key));

      verify(
        service.disconnect(),
      ).called(1);
    });

    testWidgets('shows network error', (WidgetTester tester) async {
      // FlutterError.onError = ignoreOverflowErrors;

      when(service.initError).thenReturn(
        const WalletConnectError(code: -1, message: 'Network error'),
      );
      // when(service.reconnectRelay()).thenAnswer((_) async {});

      final GlobalKey key = GlobalKey();
      // late BuildContext context;

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 100,
              child: Builder(
                builder: (context) {
                  return WalletConnectModalConnect(
                    key: key,
                    service: service,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Got the init error
      verify(service.initError).called(1);

      expect(
        find.text(
          StringConstants.connectButtonError,
          skipOffstage: false,
        ),
        findsOneWidget,
      );

      // Disabled button after tap
      await tester.tap(find.byKey(key));
      await tester.pump();
      verify(service.reconnectRelay()).called(1);
    });
  });
}
