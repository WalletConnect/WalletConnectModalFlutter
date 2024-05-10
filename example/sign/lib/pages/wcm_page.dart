import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_dapp/models/chain_metadata.dart';
import 'package:walletconnect_flutter_dapp/utils/constants.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/chain_data.dart';
import 'package:walletconnect_flutter_dapp/utils/string_constants.dart';
import 'package:walletconnect_flutter_dapp/widgets/chain_button.dart';
import 'package:walletconnect_flutter_dapp/widgets/session_widget.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

class WCMPage extends StatefulWidget {
  const WCMPage({
    super.key,
    required this.web3App,
  });

  final IWeb3App web3App;

  @override
  State<WCMPage> createState() => _WCMPageState();
}

class _WCMPageState extends State<WCMPage> with SingleTickerProviderStateMixin {
  bool _initialized = false;

  IWalletConnectModalService? _walletConnectModalService;

  ChainMetadata? _firstChain;
  final List<ChainMetadata> _selectedChains = [];

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();

    initialize();
  }

  Future<void> initialize() async {
    _walletConnectModalService = WalletConnectModalService(
      web3App: widget.web3App,
      recommendedWalletIds: {
        'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
        '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust
      },
      // excludedWalletState: ExcludedWalletState.all,
    );

    widget.web3App.onSessionConnect.subscribe(_onWeb3AppConnect);
    widget.web3App.onSessionDelete.subscribe(_onWeb3AppDisconnect);

    await _walletConnectModalService?.init();

    _isConnected = widget.web3App.sessions.getAll().isNotEmpty;

    setState(() {
      _initialized = true;
    });
  }

  @override
  void dispose() {
    widget.web3App.onSessionConnect.unsubscribe(_onWeb3AppConnect);
    widget.web3App.onSessionDelete.unsubscribe(_onWeb3AppDisconnect);
    super.dispose();
  }

  void _onWeb3AppConnect(SessionConnect? args) {
    // If we connect, default to barebones
    setState(() {
      _isConnected = true;
    });
  }

  void _onWeb3AppDisconnect(SessionDelete? args) {
    setState(() {
      _isConnected = false;
    });
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

    return Container(
      padding: const EdgeInsets.all(8),
      child: _isConnected ? _buildConnected() : _buildWalletConnect(),
    );
  }

  Widget _buildWalletConnect() {
    // Build the list of chain button
    final List<ChainMetadata> chains = ChainData.chains;

    List<Widget> chainButtons = [];

    for (final ChainMetadata chain in chains) {
      // Build the button
      chainButtons.add(
        ChainButton(
          chain: chain,
          onPressed: () {
            _selectChain(
              chain,
              // deselectOthers: true,
            );
          },
          selected: _selectedChains.contains(chain),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletConnectModal'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WalletConnectModalConnect(
            service: _walletConnectModalService!,
          ),
          // WalletConnectModalConnect(
          //   service: _walletConnectModalService!,
          //   width: double.infinity,
          //   height: 100,
          // ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const Text(
                    StringConstants.selectChains,
                    style: StyleConstants.subtitleText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: StyleConstants.linear24,
                  ),
                  // _buildTestnetSwitch(),
                  ...chainButtons,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnected() {
    final SessionData session = widget.web3App.sessions.getAll().first;

    // Assign the button based on the type

    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletConnectModal'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WalletConnectModalConnect(
            service: _walletConnectModalService!,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: SessionWidget(
                session: session,
                web3App: widget.web3App,
                launchRedirect: () {
                  final redirect = _walletConnectModalService
                      ?.session?.peer.metadata.redirect;
                  if (redirect != null) {
                    _walletConnectModalService!.launchCurrentWallet();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectChain(ChainMetadata chain) {
    setState(() {
      if (_selectedChains.contains(chain)) {
        _selectedChains.remove(chain);

        if (chain == _firstChain) {
          _firstChain = null;

          if (_selectedChains.isNotEmpty) {
            _firstChain = _selectedChains.first;
          }
        }
      } else {
        _firstChain ??= chain;
        _selectedChains.add(chain);
      }
    });
    _updateNamespaces();
  }

  void _updateNamespaces() {
    final Map<String, RequiredNamespace> requiredNamespaces = {};
    for (var chainData in _selectedChains) {
      for (var key in chainData.requiredNamespaces.keys) {
        final chains = chainData.requiredNamespaces[key]!.chains ?? [];
        final methods = chainData.requiredNamespaces[key]!.methods;
        final events = chainData.requiredNamespaces[key]!.events;

        // Adds every requiredNamespaces from every selected chain

        requiredNamespaces[key] = RequiredNamespace(
          chains: <String>{
            ...(requiredNamespaces[key]?.chains ?? []),
            ...chains
          }.toList(),
          methods: <String>{
            ...(requiredNamespaces[key]?.methods ?? []),
            ...methods
          }.toList(),
          events: <String>{
            ...(requiredNamespaces[key]?.events ?? []),
            ...events
          }.toList(),
        );
      }
    }

    _walletConnectModalService?.setRequiredNamespaces(
      requiredNamespaces: requiredNamespaces,
    );
    debugPrint('WCM Page, requiredNamespaces: $requiredNamespaces');

    final Map<String, RequiredNamespace> optionalNamespaces = {};
    for (var chainData in _selectedChains) {
      for (var key in chainData.optionalNamespaces.keys) {
        final chains = chainData.optionalNamespaces[key]!.chains ?? [];
        final methods = chainData.optionalNamespaces[key]!.methods;
        final events = chainData.optionalNamespaces[key]!.events;

        // Adds every optionalNamespaces from every selected chain

        optionalNamespaces[key] = RequiredNamespace(
          chains: <String>{
            ...(optionalNamespaces[key]?.chains ?? []),
            ...chains
          }.toList(),
          methods: <String>{
            ...(optionalNamespaces[key]?.methods ?? []),
            ...methods
          }.toList(),
          events: <String>{
            ...(optionalNamespaces[key]?.events ?? []),
            ...events
          }.toList(),
        );
      }
    }

    _walletConnectModalService?.setOptionalNamespaces(
      optionalNamespaces: optionalNamespaces,
    );
    debugPrint('WCM Page, optionalNamespaces: $optionalNamespaces');
  }
}
