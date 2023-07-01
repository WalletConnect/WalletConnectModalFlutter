import 'package:event/event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

import '../mock_classes.mocks.dart';
import 'test_data.dart';

void main() {
  group('WalletConnectModalService', () {
    late WalletConnectModalService service;
    late MockWeb3App web3App;
    late MockSessions sessions;
    late MockExplorerService explorerService;

    setUp(() {
      web3App = MockWeb3App();
      when(web3App.core).thenReturn(
        Core(projectId: 'projectId'),
      );
      when(web3App.metadata).thenReturn(
        metadata,
      );
      when(web3App.onSessionDelete).thenReturn(
        Event<SessionDelete>(),
      );

      sessions = MockSessions();
      when(web3App.sessions).thenReturn(
        sessions,
      );
      when(sessions.getAll()).thenReturn(
        [],
      );
      explorerService = MockExplorerService();
      service = WalletConnectModalService(
        web3App: web3App,
        explorerService: explorerService,
      );
    });

    group('Constructor', () {
      test(
          'throws ArgumentError when projectId, metadata, and web3App are all null',
          () {
        expect(
            () => WalletConnectModalService(), throwsA(isA<ArgumentError>()));
      });

      test('initializes _web3App with default values when web3App is null', () {
        var service = WalletConnectModalService(
          projectId: 'projectId',
          metadata: metadata,
        );

        expect(service.web3App, isNotNull);
        expect(service.projectId, 'projectId');
        expect(service.explorerService, isNotNull);
      });

      test('does not overwrite provided web3App', () {
        var web3App = Web3App(
          core: Core(projectId: 'providedProjectId'),
          metadata: metadata,
        );
        var service = WalletConnectModalService(
          web3App: web3App,
          projectId: 'projectId',
          metadata: metadata,
        );

        expect(service.web3App!.core.projectId, 'providedProjectId');
      });
    });

    group('init', () {
      test(
          'should call init on _web3App and explorerService, then skip init again',
          () async {
        when(web3App.init()).thenAnswer((_) async {});
        when(explorerService.init(referer: anyNamed('referer')))
            .thenAnswer((_) async {});

        await service.init();

        verify(web3App.init()).called(1);
        verify(explorerService.init(referer: anyNamed('referer'))).called(1);
        verify(web3App.onSessionDelete).called(1);

        await service.init();

        verifyNever(web3App.init());
        verifyNever(explorerService.init(referer: anyNamed('referer')));

        expect(service.isInitialized, isTrue);
      });

      test(
          'should set _isConnected, _session, _address if _web3App.sessions.getAll().isNotEmpty',
          () async {
        when(web3App.init()).thenAnswer((_) async {});
        when(explorerService.init(referer: anyNamed('referer'))).thenAnswer(
          (_) async {},
        );

        when(sessions.getAll()).thenReturn(
          [testSession],
        );
        await service.init();

        expect(service.isConnected, isTrue);
        expect(service.session, equals(testSession));
        expect(
          service.address,
          testSession.namespaces.values.first.accounts.first,
        );
      });
    });

    group('disconnect', () {
      test('throws if _checkInitialized fails', () async {
        expect(
          () => service.disconnect(),
          throwsA(isA<StateError>()),
        );
      });

      test('calls disconnectSession on web3App', () async {
        when(sessions.getAll()).thenReturn(
          [testSession],
        );

        await service.init();

        when(
          web3App.disconnectSession(
            topic: anyNamed('topic'),
            reason: anyNamed('reason'),
          ),
        ).thenAnswer((_) async {});

        await service.disconnect();

        verify(web3App.disconnectSession(
          topic: testSession.topic,
          reason: anyNamed('reason'),
        )).called(1);
      });
    });

    group('launchCurrentWallet', () {
      MockUrlUtils mockUrlUtils = MockUrlUtils();

      setUp(() {
        urlUtils.instance = mockUrlUtils;
        when(mockUrlUtils.launchUrl(any))
            .thenAnswer((inv) => Future.value(true));
        when(mockUrlUtils.launchRedirect(
          nativeUri: anyNamed('nativeUri'),
          universalUri: anyNamed('universalUri'),
        )).thenAnswer((inv) => Future.value());
      });

      test('throws if _checkInitialized fails', () async {
        expect(
          () => service.disconnect(),
          throwsA(isA<StateError>()),
        );

        await service.init();

        service.launchCurrentWallet();

        verifyNever(mockUrlUtils.launchUrl(any));
        verifyNever(mockUrlUtils.launchRedirect(
          nativeUri: anyNamed('nativeUri'),
          universalUri: anyNamed('universalUri'),
        ));
      });

      test('does nothing if session is null', () async {
        await service.init();

        service.launchCurrentWallet();

        verifyNever(mockUrlUtils.launchUrl(any));
        verifyNever(mockUrlUtils.launchRedirect(
          nativeUri: anyNamed('nativeUri'),
          universalUri: anyNamed('universalUri'),
        ));
      });

      test(
          'launchCurrentWallet launches url when _constructRedirect returns null',
          () async {
        when(sessions.getAll()).thenReturn(
          [testSession],
        );
        await service.init();

        when(
          explorerService.getRedirect(name: testSession.peer.metadata.name),
        ).thenReturn(null);

        service.launchCurrentWallet();

        verify(mockUrlUtils.launchUrl(
          Uri.parse(service.session!.peer.metadata.url),
        )).called(1);
        verifyNever(mockUrlUtils.launchRedirect(
          nativeUri: anyNamed('nativeUri'),
          universalUri: anyNamed('universalUri'),
        ));
      });

      test(
          'launchCurrentWallet launches redirect when _constructRedirect returns non-null',
          () async {
        when(sessions.getAll()).thenReturn(
          [testSession],
        );
        await service.init();

        final redirect = Redirect(
          native: 'https://native.com',
          universal: 'https://universal.com',
        );
        when(
          explorerService.getRedirect(name: testSession.peer.metadata.name),
        ).thenReturn(redirect);

        service.launchCurrentWallet();

        verify(mockUrlUtils.launchRedirect(
          nativeUri: Uri.parse(redirect.native!),
          universalUri: Uri.parse(redirect.universal!),
        )).called(1);
        verifyNever(mockUrlUtils.launchUrl(any));
      });
    });

    group('setRequiredNamespaces', () {
      test('throws if _checkInitialized fails', () async {
        expect(
          () => service.setRequiredNamespaces(NamespaceConstants.ethereum),
          throwsA(isA<StateError>()),
        );
      });

      test('updates internal value', () async {
        await service.init();

        service.setRequiredNamespaces(NamespaceConstants.ethereum);

        expect(service.requiredNamespaces, NamespaceConstants.ethereum);
      });
    });

    group('getReferer', () {
      test('throws if _checkInitialized fails', () async {
        expect(
          () => service.getReferer(),
          throwsA(isA<StateError>()),
        );
      });

      test('returns referer', () async {
        await service.init();

        expect(service.getReferer(), 'FlutterWalletConnect');
      });
    });
  });
}
