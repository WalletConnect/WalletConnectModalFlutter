import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';

final List<Listing> testListings1 = [
  const Listing(
    id: '1',
    name: 'Test1',
    homepage: 'https://test1.com',
    imageId: 'test',
    app: App(),
    mobile: Redirect(
      universal: 'https://test1.com',
      native: 'https://test1.com',
    ),
    desktop: Redirect(),
  ),
  const Listing(
    id: '2',
    name: 'Test2',
    homepage: 'https://test2.com',
    imageId: 'test',
    app: App(),
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

const metadata = PairingMetadata(
  name: 'Flutter WalletConnect',
  description: 'Flutter Web3Modal Sign Example',
  url: 'https://walletconnect.com/',
  icons: ['https://walletconnect.com/walletconnect-logo.png'],
);

const connectionMetadata = ConnectionMetadata(
  publicKey: '0xabc',
  metadata: metadata,
);

final testSession = SessionData(
  topic: 'a',
  pairingTopic: 'b',
  relay: Relay('irn'),
  expiry: 1,
  acknowledged: true,
  controller: 'test',
  namespaces: {
    'test': const Namespace(
      accounts: ['abc'],
      methods: ['method1'],
      events: [],
    ),
  },
  self: connectionMetadata,
  peer: connectionMetadata,
);
