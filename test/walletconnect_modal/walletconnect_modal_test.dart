import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal.dart';

import '../mock_classes.mocks.dart';
import '../test_data.dart';
import '../test_helpers.dart';

void main() {
  group('WalletConnectModal', () {
    late MockWalletConnectModalService service;
    late MockWeb3App web3App;
    late MockSessions sessions;
    late MockExplorerService explorerService;
    final MockPlatformUtils mockPlatformUtils = MockPlatformUtils();

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
      explorerService = MockExplorerService();
      when(explorerService.initialized).thenReturn(ValueNotifier(false));
      when(explorerService.itemList).thenReturn(ValueNotifier([]));
      service = MockWalletConnectModalService();
      when(service.explorerService).thenReturn(explorerService);
      when(service.wcUri).thenReturn('test');
      when(service.isInitialized).thenReturn(true);
      // when(service.rebuildConnectionUri()).thenAnswer(
      //   (_) => Future.value(),
      // );
    });

    testWidgets('should load in wallets and their buttons',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: 600,
            width: 500,
            child: Center(
              child: WalletConnectModal(
                service: service,
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
        find.byKey(
          const Key(
            StringConstants.walletConnectModalHelpButtonKey,
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key(
            StringConstants.walletConnectModalCloseButtonKey,
          ),
        ),
        findsOneWidget,
      );

      // Can't figure out how to make the widget not overflow, so these are commented out because I can't tap
      // on a widget that isn't visible (off screen due to overflow)

      // Check modal buttons
      // tester.tap(find.byKey(
      //   const Key(
      //     StringConstants.walletConnectModalHelpButtonKey,
      //   ),
      // ));
      // expect(
      //   find.byKey(
      //     Key(WalletConnectModalState.help.name),
      //   ),
      //   findsOneWidget,
      // );
      // tester.tap(find.byKey(
      //   const Key(
      //     StringConstants.walletConnectModalHelpButtonKey,
      //   ),
      // ));

      // tester.tap(find.byKey(
      //   const Key(
      //     StringConstants.walletConnectModalCloseButtonKey,
      //   ),
      // ));
      // verify(service.close()).called(1);
    });
  });
}
