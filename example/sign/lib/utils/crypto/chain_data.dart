import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_dapp/models/chain_metadata.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/eip155.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/polkadot.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/solana.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ChainData {
  static final List<ChainMetadata> chains = [
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.blue.shade300,
      chainName: 'Ethereum',
      namespace: 'eip155:1',
      chainId: '1',
      chainIcon: '692ed6ba-e569-459a-556a-776476829e00',
      tokenName: 'ETH',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://eth.drpc.org',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.purple.shade300,
      chainName: 'Polygon',
      namespace: 'eip155:137',
      chainId: '137',
      chainIcon: '41d04d42-da3b-4453-8506-668cc0727900',
      tokenName: 'MATIC',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:137'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:137'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://polygon.drpc.org',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.purple.shade900,
      chainName: 'Arbitrum',
      namespace: 'eip155:42161',
      chainId: '42161',
      chainIcon: '600a9a04-c1b9-42ca-6785-9b4b6ff85200',
      tokenName: 'ARB',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:42161'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:42161'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://arbitrum.blockpi.network/v1/rpc/public',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.red.shade400,
      chainName: 'Avalanche',
      namespace: 'eip155:43114',
      chainId: '43114',
      chainIcon: '30c46e53-e989-45fb-4549-be3bd4eb3b00',
      tokenName: 'AVAX',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:43114'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:43114'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://api.avax.network/ext/bc/C/rpc',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.yellow.shade600,
      chainName: 'Binance Smart Chain',
      namespace: 'eip155:56',
      chainId: '56',
      chainIcon: '93564157-2e8e-4ce7-81df-b264dbee9b00',
      tokenName: 'BNB',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:56'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:56'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://bsc-dataseed.binance.org/',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.blue.shade300,
      chainName: 'Fantom',
      namespace: 'eip155:250',
      chainId: '250',
      chainIcon: '06b26297-fe0c-4733-5d6b-ffa5498aac00',
      tokenName: 'FTM',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:250'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:250'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://rpc.ftm.tools/',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.red.shade700,
      chainName: 'Optimism',
      namespace: 'eip155:10',
      chainId: '10',
      chainIcon: 'ab9c186a-c52f-464b-2906-ca59d760a400',
      tokenName: 'OP',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:10'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:10'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://mainnet.optimism.io/',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.blue.shade800,
      chainName: 'EVMos',
      namespace: 'eip155:9001',
      chainId: '9001',
      chainIcon: 'f926ff41-260d-4028-635e-91913fc28e00',
      tokenName: 'EVMOS',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:9001'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:9001'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://eth.bd.evmos.org:8545',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.purple.shade800,
      chainName: 'Iotx',
      namespace: 'eip155:4689',
      chainId: '4689',
      chainIcon: '34e68754-e536-40da-c153-6ef2e7188a00',
      tokenName: 'IOTX',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:4689'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:4689'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://rpc.ankr.com/iotex',
    ),
    ChainMetadata(
      type: ChainType.eip155,
      color: Colors.purple.shade700,
      chainName: 'Metis',
      namespace: 'eip155:1088',
      chainId: '1088',
      chainIcon: '3897a66d-40b9-4833-162f-a2c90531c900',
      tokenName: 'METIS',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1088'],
          methods: EIP155.requiredMethods,
          events: EIP155.requiredEvents,
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1088'],
          methods: EIP155.optionalMethods,
          events: EIP155.optionalEvents,
        ),
      },
      rpcUrl: 'https://metis-mainnet.public.blastapi.io',
    ),
    const ChainMetadata(
      type: ChainType.polkadot,
      chainId: '91b171bb158e2d3848fa23a9f1c25182',
      namespace: 'polkadot:91b171bb158e2d3848fa23a9f1c25182',
      chainName: 'Polkadot Mainnet',
      chainIcon: '/chain-logos/polkadot.png',
      color: Color.fromARGB(255, 255, 18, 192),
      rpcUrl: 'wss://rpc.polkadot.io',
      tokenName: 'DOT',
      requiredNamespaces: {},
      optionalNamespaces: {
        'polkadot': RequiredNamespace(
          chains: ['polkadot:91b171bb158e2d3848fa23a9f1c25182'],
          methods: Polkadot.methods,
          events: Polkadot.events,
        ),
      },
    ),
    const ChainMetadata(
      type: ChainType.solana,
      chainId: '5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp',
      namespace: 'solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp',
      chainName: 'Solana Mainnet',
      chainIcon: '/chain-logos/solana.png',
      color: Color.fromARGB(255, 176, 30, 255),
      rpcUrl: 'https://api.tatum.io/v3/blockchain/node/solana-mainnet',
      tokenName: 'SOL',
      requiredNamespaces: {},
      optionalNamespaces: {
        'solana': RequiredNamespace(
          chains: ['solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp'],
          methods: Solana.methods,
          events: Solana.events,
        ),
      },
    ),
  ];
}
