import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/pages/get_wallet_page.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_item_model.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_button.dart';

import '../mock_classes.mocks.dart';
import '../test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetAWallet', () {
    late MockExplorerService es;

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

      es = MockExplorerService();
      when(
        es.init(),
      ).thenAnswer((_) async {});
      when(es.initialized).thenReturn(ValueNotifier(true));
      when(es.itemList).thenReturn(walletData);
      explorerService.instance = es;
    });

    testWidgets('should load in wallets and their buttons',
        (WidgetTester tester) async {
      // FlutterError.onError = ignoreOverflowErrors;

      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GetWalletPage(),
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
    });

    testWidgets('should load in wallets and their buttons',
        (WidgetTester tester) async {
      // FlutterError.onError = ignoreOverflowErrors;

      final List<GridListItemModel<WalletData>> wallets = [
        GridListItemModel(
          image: 'test',
          id: '1',
          title: 'Test1',
          data: WalletData(
            listing: testListings1[0],
            installed: false,
            recent: false,
          ),
        ),
        GridListItemModel(
          image: 'test',
          id: '2',
          title: 'Test2',
          data: WalletData(
            listing: testListings1[1],
            installed: false,
            recent: false,
          ),
        ),
      ];
      walletData.value = wallets;

      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GetWalletPage(),
            ),
          ),
        );

        expect(
          find.byType(WalletItem, skipOffstage: false),
          findsNWidgets(2),
        );
      });
    });
  });
}
