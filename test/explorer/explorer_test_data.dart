import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';

final List<Listing> testListings1 = [
  Listing(
    id: '1',
    name: 'Test1',
    homepage: 'https://test1.com',
    imageId: 'test',
    app: const App(),
    mobile: Redirect(
      universal: 'https://test1.com',
      native: 'https://test1.com',
    ),
    desktop: Redirect(),
  ),
  Listing(
    id: '2',
    name: 'Test2',
    homepage: 'https://test2.com',
    imageId: 'test',
    app: const App(),
    mobile: Redirect(
      universal: 'https://test2.com',
      native: 'https://test2.com',
    ),
    desktop: Redirect(),
  ),
];

final ListingResponse testResponse1 = ListingResponse(
  listings: Map.fromIterable(
    testListings1,
    key: (e) => e.id,
  ),
  total: testListings1.length,
);
