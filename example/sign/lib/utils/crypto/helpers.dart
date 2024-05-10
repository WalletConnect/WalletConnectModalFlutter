import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_dapp/models/chain_metadata.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/chain_data.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/eip155.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/polkadot.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/solana.dart';

ChainMetadata getChainMetadataFromChain(String namespace) {
  try {
    return ChainData.chains
        .where((element) => element.namespace == namespace)
        .first;
  } catch (e) {
    debugPrint('getChainMetadataFromChain, Invalid chain: $namespace');
  }
  return ChainData.chains[0];
}

List<String> getChainEvents(ChainType value) {
  if (value == ChainType.solana) {
    return [];
  } else if (value == ChainType.kadena) {
    return EIP155.events.values.toList(); //Kadena.events.values.toList();
  } else if (value == ChainType.eip155) {
    return EIP155.events.values.toList();
  } else {
    return [];
  }
}

List<String> getUIChainMethods(ChainType value) {
  if (value == ChainType.solana) {
    return Solana.methods;
  } else if (value == ChainType.kadena) {
    return EIP155.methods.values.toList(); //Kadena.methods.values.toList();
  } else if (value == ChainType.polkadot) {
    return Polkadot.methods;
  } else if (value == ChainType.eip155) {
    return EIP155.methods.values.toList();
  } else {
    return [];
  }
}
