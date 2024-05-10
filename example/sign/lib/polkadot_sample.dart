import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:walletconnect_flutter_dapp/utils/crypto/contract.dart';
import 'package:walletconnect_flutter_dapp/utils/dart_defines.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

class PolkadotSamplePage extends StatefulWidget {
  const PolkadotSamplePage({super.key});

  @override
  State<PolkadotSamplePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PolkadotSamplePage> {
  bool _initialized = false;
  IWalletConnectModalService? _modalService;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    _modalService = WalletConnectModalService(
      projectId: DartDefines.projectId,
      metadata: const PairingMetadata(
        name: 'Flutter Dapp Example',
        description: 'Flutter Dapp Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          methods: [
            'personal_sign',
            'eth_sendTransaction',
          ],
          events: [
            'chainChanged',
            'accountsChanged',
          ],
        ),
      },
      optionalNamespaces: {
        'polkadot': const RequiredNamespace(
          chains: ['polkadot:91b171bb158e2d3848fa23a9f1c25182'],
          methods: [
            'polkadot_signMessage',
            'polkadot_signTransaction',
          ],
          events: [],
        ),
      },
    );

    await _modalService!.init();

    _modalService!.web3App!.onSessionConnect.subscribe(_onSessionConnect);
    _modalService!.web3App!.onSessionDelete.subscribe(_onSessionDisonnect);
    _modalService!.web3App!.onSessionEvent.subscribe(_onSessionEvent);

    setState(() => _initialized = true);
  }

  void _onSessionConnect(SessionConnect? args) {
    log('_onSessionConnect ${jsonEncode(args?.session.toJson())}');
    setState(() {});
  }

  void _onSessionDisonnect(SessionDelete? args) {
    log('_onSessionDisonnect ${args.toString()}');
    setState(() {});
  }

  void _onSessionEvent(SessionEvent? args) {
    log('_onSessionEvent ${args.toString()}');
    setState(() {});
  }

  void requestReadContract() {
    final deployedContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode(ContractDetails.readContractAbi),
        'Tether USD',
      ),
      EthereumAddress.fromHex(ContractDetails.contractAddress),
    );

    _modalService!.web3App!.requestReadContract(
      deployedContract: deployedContract,
      functionName: 'balanceOf',
      rpcUrl: 'https://eth.drpc.org',
      parameters: [
        // address to read balance of
        EthereumAddress.fromHex('0x......'),
      ],
    );
  }

  void requestWriteContract() {
    final deployedContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode(ContractDetails.readContractAbi),
        'Tether USD',
      ),
      EthereumAddress.fromHex(ContractDetails.contractAddress),
    );

    _modalService!.web3App!.requestWriteContract(
      deployedContract: deployedContract,
      topic: _modalService!.session!.topic,
      chainId: 'eip155:1',
      rpcUrl: 'https://eth.drpc.org',
      functionName: 'transfer',
      transaction: Transaction(
        from: EthereumAddress.fromHex(_modalService!.address!),
      ),
      parameters: [
        // address to transfer to
        EthereumAddress.fromHex('0x....'),
        BigInt.from(0.0000000000001),
      ],
    );
  }

  @override
  void dispose() {
    _modalService!.web3App!.onSessionConnect.unsubscribe(_onSessionConnect);
    _modalService!.web3App!.onSessionDelete.unsubscribe(_onSessionDisonnect);
    _modalService!.web3App!.onSessionEvent.unsubscribe(_onSessionEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(
        child: CircularProgressIndicator(
          color: WalletConnectModalTheme.getData(context).primary100,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletConnectModal'),
      ),
      body: Center(
        child: Column(
          children: [
            WalletConnectModalConnect(
              service: _modalService!,
            ),
            Visibility(
              visible: _modalService!.isConnected,
              child: ElevatedButton(
                onPressed: () async {
                  final account = _modalService!
                      .session!.namespaces['polkadot']!.accounts.last;
                  final address = account.split(":").last;
                  final result = await _modalService!.web3App!.request(
                    topic: _modalService!.session!.topic,
                    chainId: 'polkadot:91b171bb158e2d3848fa23a9f1c25182',
                    request: SessionRequestParams(
                      method: 'polkadot_signMessage',
                      params: {
                        'address': address,
                        'message': 'This is an example message',
                      },
                    ),
                  );
                  debugPrint('result $result');
                },
                child: const Text('polkadot_signMessage'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
