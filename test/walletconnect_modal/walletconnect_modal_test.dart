import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';

import '../mock_classes.mocks.dart';
import '../test_data.dart';

void main() {
  group('WalletConnectModal', () {
    late MockWalletConnectModalService service;
    late MockWeb3App web3App;
    late MockSessions sessions;
    late MockPairingStore pairings;
    late MockExplorerService es;
    final mockPlatformUtils = MockPlatformUtils();

    setUp(() async {
      // Setup the singletons
      when(mockPlatformUtils.getPlatformType()).thenReturn(PlatformType.mobile);
      when(mockPlatformUtils.isMobileWidth(any)).thenReturn(true);
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
      when(es.initialized).thenReturn(ValueNotifier(true));
      when(es.itemList).thenReturn(ValueNotifier(itemList));
      explorerService.instance = es;

      service = MockWalletConnectModalService();
      when(service.onPairingExpireEvent).thenReturn(
        Event(),
      );
      when(service.wcUri).thenReturn('test');
      when(service.isInitialized).thenReturn(true);
      // when(service.rebuildConnectionUri()).thenAnswer(
      //   (_) => Future.value(),
      // );
    });

    testWidgets('loads pages correctly', (WidgetTester tester) async {
      // FlutterError.onError = ignoreOverflowErrors;
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await mockNetworkImagesFor(() async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(
          MaterialApp(
            home: SizedBox(
              height: 800,
              width: 800,
              child: Center(
                child: WalletConnectModalProvider(
                  service: service,
                  child: Scaffold(
                    body: Builder(
                      builder: (context) {
                        return const WalletConnectModal();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Check initial state
        expect(
          find.byKey(WalletConnectModalConstants.qrCodeAndWalletListPageKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.helpButtonKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.closeModalButtonKey),
          findsOneWidget,
        );

        // Can't figure out how to make the widget not overflow, so these are commented out because I can't tap
        // on a widget that isn't visible (off screen due to overflow)

        // Navbar Back Button doesn't exist on home
        expect(
          find.byKey(WalletConnectModalConstants.navbarBackButtonKey),
          findsNothing,
        );

        // Tap on Help Button from initial page
        await tester.tap(find.byKey(WalletConnectModalConstants.helpButtonKey));
        await tester.pumpAndSettle();
        // Shows What is a wallet screen
        expect(
          find.byKey(WalletConnectModalConstants.helpPageKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.navbarBackButtonKey),
          findsOneWidget,
        );

        // Tap on Get a Wallet Button from What is a wallet screen page
        await tester
            .tap(find.byKey(WalletConnectModalConstants.getAWalletButtonKey));
        await tester.pumpAndSettle();
        // Shows Get a wallet page
        expect(
          find.byKey(WalletConnectModalConstants.getAWalletPageKey),
          findsOneWidget,
        );

        // Tap on Help Button from Get a wallet page
        expect(
          find.byKey(WalletConnectModalConstants.helpButtonKey),
          findsOneWidget,
        );
        await tester.tap(
          find.byKey(WalletConnectModalConstants.helpButtonKey),
        );
        // Should pop back to What is a wallet page
        await tester.pumpAndSettle();
        expect(
          find.byKey(WalletConnectModalConstants.helpPageKey),
          findsOneWidget,
        );
        expect(
          find.text('What is a wallet?'),
          findsOneWidget,
        );

        // Tap on Help Button from What is a wallet page
        expect(
          find.byKey(WalletConnectModalConstants.helpButtonKey),
          findsOneWidget,
        );
        await tester.tap(
          find.byKey(WalletConnectModalConstants.helpButtonKey),
        );
        // should go back to home
        await tester.pumpAndSettle();
        expect(
          find.text('Connect your wallet'),
          findsOneWidget,
        );
        // Check initial state again
        expect(
          find.byKey(WalletConnectModalConstants.qrCodeAndWalletListPageKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.helpButtonKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.closeModalButtonKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.navbarBackButtonKey),
          findsNothing,
        );

        // Grid List - View All
        expect(
          find.byKey(WalletConnectModalConstants.gridListViewAllButtonKey),
          findsOneWidget,
        );
        await tester.tap(
          find.byKey(WalletConnectModalConstants.gridListViewAllButtonKey),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(WalletConnectModalConstants.walletListLongPageKey),
          findsOneWidget,
        );

        // Navbar Back Button
        expect(
          find.byKey(WalletConnectModalConstants.navbarBackButtonKey),
          findsOneWidget,
        );
        await tester.tap(find.byKey(
          WalletConnectModalConstants.navbarBackButtonKey,
        ));
        await tester.pumpAndSettle();
        expect(
          find.byKey(WalletConnectModalConstants.qrCodeAndWalletListPageKey),
          findsOneWidget,
        );
        expect(
          find.byKey(WalletConnectModalConstants.navbarBackButtonKey),
          findsNothing,
        );

        // Close
        await tester.tap(find.byKey(
          WalletConnectModalConstants.closeModalButtonKey,
        ));
        await tester.pump();
        verify(service.close()).called(1);
      });
    });
  });
}
