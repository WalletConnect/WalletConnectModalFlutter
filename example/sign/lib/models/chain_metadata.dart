import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

enum ChainType {
  eip155,
  solana,
  kadena,
  polkadot,
}

class ChainMetadata {
  final Color color;
  final ChainType type;
  final String chainName;
  final String chainId;
  final String namespace;
  final String chainIcon;
  final String tokenName;
  final Map<String, RequiredNamespace> requiredNamespaces;
  final Map<String, RequiredNamespace> optionalNamespaces;
  final String rpcUrl;

  const ChainMetadata({
    required this.color,
    required this.type,
    required this.chainName,
    required this.chainId,
    required this.namespace,
    required this.chainIcon,
    required this.tokenName,
    required this.requiredNamespaces,
    required this.optionalNamespaces,
    required this.rpcUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChainMetadata &&
        other.color == color &&
        other.type == type &&
        other.chainName == chainName &&
        other.chainId == chainId &&
        other.namespace == namespace &&
        other.chainIcon == chainIcon &&
        other.tokenName == tokenName &&
        other.requiredNamespaces == requiredNamespaces &&
        other.optionalNamespaces == optionalNamespaces &&
        other.rpcUrl == rpcUrl;
  }

  @override
  int get hashCode {
    return color.hashCode ^
        type.hashCode ^
        chainName.hashCode ^
        chainId.hashCode ^
        namespace.hashCode ^
        chainIcon.hashCode ^
        tokenName.hashCode ^
        requiredNamespaces.hashCode ^
        optionalNamespaces.hashCode ^
        rpcUrl.hashCode;
  }
}
