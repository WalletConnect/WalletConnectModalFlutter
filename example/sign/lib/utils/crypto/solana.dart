import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:bs58/bs58.dart';

import 'package:flutter/foundation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class Solana {
  static const methods = [
    'solana_signMessage',
    'solana_signTransaction',
  ];

  static const events = <String>[];

  static Future<dynamic> callMethod({
    required IWeb3App web3App,
    required String topic,
    required String method,
    required String chainId,
    required String address,
  }) {
    debugPrint('callMethod $method, chainId: $chainId, address: $address');
    final bytes = utf8.encode(
      'This is an example message to be signed - ${DateTime.now()}',
    );
    final message = base58.encode(bytes);
    switch (method) {
      case 'solana_signMessage':
        return web3App.request(
          topic: topic,
          chainId: chainId,
          request: SessionRequestParams(
            method: method,
            params: {
              'pubkey': address,
              'message': message,
            },
          ),
        );
      case 'solana_signTransaction':
        return web3App.request(
          topic: topic,
          chainId: chainId,
          request: SessionRequestParams(
            method: method,
            params: {
              "feePayer": address,
              "recentBlockhash": "H32Ss1hxpP2ZJM4whREVNyUWRgzFLVA97UXJUjBrEsgx",
              "instructions": [
                {
                  "programId": "11111111111111111111111111111111",
                  "data": [2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
                  "keys": [
                    {
                      "isSigner": true,
                      "isWritable": true,
                      "pubkey": "EbdEmCpKGvEwfwV4ACmVYHFRkwvXdogJhMZeEekDFVVJ"
                    },
                    {
                      "isSigner": false,
                      "isWritable": true,
                      "pubkey": "4SzUq9NNYSYGp41ED5NgSDoCrEh9MoD7zSvmtkwseW8s"
                    }
                  ]
                }
              ]
            },
          ),
        );
      default:
        return Future.value();
    }
  }
}
