import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

import '../mock_classes.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletConnectModalService', () {
    late MockWalletConnectModalService service;

    setUp(() async {
      service = MockWalletConnectModalService();
      when(service.isConnected).thenReturn(false);
      when(service.isOpen).thenReturn(false);
    });

    testWidgets('should open or disconnect on tap',
        (WidgetTester tester) async {
      // FlutterError.onError = ignoreOverflowErrors;

      final GlobalKey key = GlobalKey();

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 100,
              child: WalletConnectModalConnect(
                key: key,
                walletConnectModalService: service,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Connect flow
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

      when(service.isConnected).thenReturn(false);
      when(service.isOpen).thenReturn(true);
      service.notifyListeners();

      await tester.pumpAndSettle();

      // expect(
      //   find.text(
      //     StringConstants.connectButtonConnecting,
      //     skipOffstage: false,
      //   ),
      //   findsOneWidget,
      // );

      when(service.isConnected).thenReturn(true);
      when(service.isOpen).thenReturn(true);
      service.notifyListeners();

      await tester.pumpAndSettle();

      // expect(
      //   find.text(StringConstants.connectButtonAccount),
      //   findsOneWidget,
      // );

      // Disconnect flow
      await tester.tap(find.byKey(key));

      verify(
        service.disconnect(),
      ).called(1);
    });
  });
}
