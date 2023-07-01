import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

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
