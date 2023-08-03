import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/pages/get_wallet_page.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_item_model.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_button.dart';

import '../mock_classes.mocks.dart';
import '../test_data.dart';
import '../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetAWallet', () {
    late MockExplorerService explorerService;

    final MockPlatformUtils mockPlatformUtils = MockPlatformUtils();
    final MockUrlUtils mockUrlUtils = MockUrlUtils();

    final ValueNotifier<List<GridListItemModel<WalletData>>> walletData =
        ValueNotifier([]);

    setUp(() async {
      // Setup the singletons
      when(mockPlatformUtils.getPlatformType()).thenReturn(PlatformType.mobile);
      when(mockPlatformUtils.isBottomSheet()).thenReturn(true);
      when(mockPlatformUtils.isLongBottomSheet(any)).thenReturn(false);
      when(mockPlatformUtils.isMobileWidth(any)).thenReturn(true);
      platformUtils.instance = mockPlatformUtils;

      when(mockUrlUtils.launchUrl(any)).thenAnswer(
        (_) => Future.value(true),
      );
      urlUtils.instance = mockUrlUtils;

      explorerService = MockExplorerService();
      when(
        explorerService.init(),
      ).thenAnswer((_) async {});
      when(explorerService.initialized).thenReturn(ValueNotifier(true));
      when(explorerService.itemList).thenReturn(walletData);
    });

    testWidgets('should load in wallets and their buttons',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      await tester.pumpWidget(
        MaterialApp(
          home: GetWalletPage(
            service: explorerService,
          ),
        ),
      );

      expect(
        find.byType(WalletConnectModalButton),
        findsOneWidget,
      );

      // Tap on the explorer button and verify it calls the launch URL we expect
      await tester.tap(find.byType(WalletConnectModalButton));

      verify(mockUrlUtils.launchUrl(
        Uri.parse(StringConstants.getAWalletExploreWalletsUrl),
      )).called(1);
    });

    testWidgets('should load in wallets and their buttons',
        (WidgetTester tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      final List<GridListItemModel<WalletData>> wallets = [
        GridListItemModel(
          image: 'test',
          id: '1',
          title: 'Test1',
          data: WalletData(
            listing: testListings1[0],
            installed: false,
          ),
        ),
        GridListItemModel(
          image: 'test',
          id: '2',
          title: 'Test2',
          data: WalletData(
            listing: testListings1[1],
            installed: false,
          ),
        ),
      ];
      walletData.value = wallets;

      await tester.pumpWidget(
        MaterialApp(
          home: GetWalletPage(
            service: explorerService,
          ),
        ),
      );

      expect(
        find.byType(WalletItem, skipOffstage: false),
        findsNWidgets(2),
      );
    });
  });
}
