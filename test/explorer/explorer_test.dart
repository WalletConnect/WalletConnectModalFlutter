import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service.dart';
import 'package:walletconnect_modal_flutter/services/storage_service/storage_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/i_platform_utils.dart';
import 'package:walletconnect_modal_flutter/services/utils/platform/platform_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';

import '../test_data.dart';
import '../mock_classes.mocks.dart';

void main() {
  group('ExplorerService', () {
    late MockClient mockClient;
    late MockStorageService mockStorageService;
    late MockUrlUtils mockUrlUtils;
    late MockPlatformUtils mockPlatformUtils;

    late ExplorerService explorerService;

    setUp(() {
      mockClient = MockClient();
      mockStorageService = MockStorageService();
      mockUrlUtils = MockUrlUtils();
      mockPlatformUtils = MockPlatformUtils();

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          json.encode(testResponse1.toJson()),
          200,
        ),
      );

      storageService.instance = mockStorageService;
      when(mockStorageService.setString(any, any)).thenAnswer(
        (realInvocation) => Future.value(true),
      );
      when(
        mockStorageService.getString(StringConstants.recentWallet),
      ).thenReturn(null);

      urlUtils.instance = mockUrlUtils;
      when(
        urlUtils.instance.isInstalled(
          testListings1[0].mobile.native,
        ),
      ).thenAnswer((_) async => true);
      when(
        urlUtils.instance.isInstalled(
          testListings1[1].mobile.native,
        ),
      ).thenAnswer((_) async => false);

      platformUtils.instance = mockPlatformUtils;
      when(
        platformUtils.instance.getPlatformType(),
      ).thenReturn(PlatformType.mobile);

      explorerService = ExplorerService(
        projectId: 'test',
        referer: 'ref',
        client: mockClient,
      );
    });

    test('Test Initialization', () async {
      await explorerService.init();

      // add assertions based on your expected outcomes
      expect(
        explorerService.initialized.value,
        equals(true),
      );
      expect(
        explorerService.itemList.value.length,
        equals(2),
      );
      expect(
        explorerService.itemList.value[0].data.listing.name,
        equals('Test1'),
      );
      expect(
        explorerService.itemList.value[0].data.installed,
        true,
      );
      expect(
        explorerService.itemList.value[1].data.listing.name,
        equals('Test2'),
      );
      expect(
        explorerService.itemList.value[1].data.installed,
        false,
      );
      verify(
        mockStorageService.getString(StringConstants.recentWallet),
      ).called(1);
    });

    group('After init', () {
      setUp(() async {
        await explorerService.init();
      });

      test('Test Filter Functionality', () async {
        explorerService.filterList(query: 'Test2');

        // add assertions based on your expected outcomes
        expect(
          explorerService.itemList.value.length,
          equals(1),
        );
        expect(
          explorerService.itemList.value[0].data.listing.name,
          equals('Test2'),
        );

        explorerService.filterList();
      });

      test('Test Redirect Fetching', () {
        Redirect? redirect = explorerService.getRedirect(name: 'blank');
        expect(redirect, null);

        redirect = explorerService.getRedirect(name: 'Test');
        expect(redirect != null, true);
        expect(redirect!.universal, equals('https://test1.com'));

        redirect = explorerService.getRedirect(name: 'Test2');
        expect(redirect != null, true);
        expect(redirect!.universal, equals('https://test2.com'));
      });
    });

    test('Test Image URL Generation', () {
      String imageId = 'test_id';
      expect(
        explorerService.getWalletImageUrl(imageId: imageId),
        equals(
          'https://explorer-api.walletconnect.com/w3m/v1/getWalletImage/test_id?projectId=test',
        ),
      );
      expect(
        explorerService.getAssetImageUrl(imageId: imageId),
        equals(
          'https://explorer-api.walletconnect.com/w3m/v1/getAssetImage/test_id?projectId=test',
        ),
      );
    });

    test('Test Fetching of Wallet Listings', () async {
      final List<Listing> listings = await explorerService.fetchListings(
        endpoint: '/w3m/v1/getDesktopListings',
        referer: 'test_referer',
      );

      // add assertions based on your expected outcomes
      expect(
        listings.length,
        equals(2),
      );
      expect(
        listings[0].name,
        equals('Test1'),
      );
      expect(
        listings[1].name,
        equals('Test2'),
      );
    });

    test('Test Filtering of Excluded Listings', () {
      explorerService.excludedWalletIds = {'1'};
      var filteredListings = explorerService.filterExcludedListings(
        listings: testListings1,
      );

      expect(
        filteredListings,
        equals(
          [
            testListings1[1],
          ],
        ),
      );
    });
  });
}
