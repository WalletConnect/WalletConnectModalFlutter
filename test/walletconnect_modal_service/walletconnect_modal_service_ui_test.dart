import 'dart:async';

import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal.dart';

import '../mock_classes.mocks.dart';
import '../test_data.dart';
import '../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletConnectModalService', () {
    late WalletConnectModalService service;
    late MockWeb3App web3App;
    late MockSessions sessions;
    late MockPairingStore pairings;
    late MockExplorerService es;

    // Assuming these objects have been defined somewhere in your actual code
    var mockPlatformUtils = MockPlatformUtils();

    setUp(() async {
      // Setup the singletons
      when(mockPlatformUtils.isBottomSheet()).thenReturn(true);
      when(mockPlatformUtils.isLongBottomSheet(any)).thenReturn(false);
      platformUtils.instance = mockPlatformUtils;

      toastUtils.instance = MockToastUtils();
      when(toastUtils.instance.toasts).thenAnswer((_) => const Stream.empty());

      web3App = MockWeb3App();
      when(web3App.core).thenReturn(
        Core(projectId: 'projectId'),
      );
      when(web3App.metadata).thenReturn(
        metadata,
      );
      when(web3App.onSessionDelete).thenReturn(
        Event<SessionDelete>(),
      );
      when(web3App.onSessionConnect).thenReturn(
        Event<SessionConnect>(),
      );
      when(web3App.init()).thenAnswer((_) async {});
      when(web3App.connect(
        requiredNamespaces: anyNamed('requiredNamespaces'),
        optionalNamespaces: anyNamed('optionalNamespaces'),
      )).thenAnswer(
        (_) async => ConnectResponse(
          pairingTopic: 'pTopic',
          session: Completer<SessionData>(),
        ),
      );

      sessions = MockSessions();
      when(web3App.sessions).thenReturn(
        sessions,
      );
      when(sessions.getAll()).thenReturn(
        [],
      );

      pairings = MockPairingStore();
      when(web3App.pairings).thenReturn(
        pairings,
      );
      when(pairings.getAll()).thenReturn(
        [],
      );

      es = MockExplorerService();
      when(
        es.init(),
      ).thenAnswer((_) async {});
      when(es.initialized).thenReturn(ValueNotifier(true));
      when(es.itemList).thenReturn(ValueNotifier([]));

      service = WalletConnectModalService(
        web3App: web3App,
        // explorerService: explorerService,
      );

      explorerService.instance = es;

      await service.init();
    });

    testWidgets('should open bottom sheet on mobile',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      when(mockPlatformUtils.getPlatformType()).thenReturn(PlatformType.mobile);
      when(mockPlatformUtils.isMobileWidth(any)).thenReturn(true);

      final GlobalKey key = GlobalKey();

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              key: key,
              builder: (BuildContext context) {
                return Container();
              },
            ),
          ),
        ),
      );

      service.open(context: key.currentContext!);

      await tester.pumpAndSettle();

      verifyNever(
        web3App.connect(
          requiredNamespaces: anyNamed('requiredNamespaces'),
          optionalNamespaces: anyNamed('optionalNamespaces'),
        ),
      );
      verify(es.filterList(query: '')).called(1);
      // Once by the open, again by the WalletConnectModal in its init
      verify(mockPlatformUtils.getPlatformType()).called(1);
      expect(find.byType(WalletConnectModal), findsOneWidget);

      service.close();

      await tester.pumpAndSettle();

      verify(toastUtils.instance.clear()).called(1);
    });

    // testWidgets('should open dialog on non-mobile',
    //     (WidgetTester tester) async {
    //   final GlobalKey key = GlobalKey();

    //   // Build our app and trigger a frame.
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Scaffold(
    //         body: Builder(
    //           key: key,
    //           builder: (BuildContext context) {
    //             return Container();
    //           },
    //         ),
    //       ),
    //     ),
    //   );

    //   when(mockPlatformUtils.getPlatformType())
    //       .thenReturn(PlatformType.desktop);
    //   when(mockPlatformUtils.isMobileWidth(any)).thenReturn(false);

    //   await service.open(context: key.currentContext!);

    //   verify(mockPlatformUtils.getPlatformType()).called(1);
    //   verify(mockPlatformUtils.isMobileWidth(any)).called(1);
    //   expect(find.byType(WalletConnectModal), findsOneWidget);
    // });
  });
}
