import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'metamask_service.dart';

class WalletConnector {
  late WalletConnect connector;
  SessionStatus? session;
  String? account;
  late Web3Client client;
  late WalletConnectEthereumCredentials credentials;

  final String rpcUrl = 'https://rpc.ankr.com/eth_goerli'; // Use Goerli or another testnet
  final int chainId = 5;

  Future<void> connect() async {
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'MyDapp',
        description: 'A decentralized app',
        url: 'https://walletconnect.org',
        icons: ['https://walletconnect.org/walletconnect-logo.png'],
      ),
    );

    connector.on('connect', (session) => print('Connected: $session'));
    connector.on('session_update', (payload) => print('Session updated: $payload'));
    connector.on('disconnect', (session) => print('Disconnected: $session'));

    if (!connector.connected) {
      session = await connector.createSession(
        chainId: chainId,
        onDisplayUri: (uri) async {
          print('WalletConnect URI: $uri');
          await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
        },
      );
    }

    account = session?.accounts.first;
    final provider = EthereumWalletConnectProvider(connector);
    credentials = WalletConnectEthereumCredentials(provider: provider);

    client = Web3Client(rpcUrl, Client());
  }

  EthereumAddress getAccountAddress() {
    return EthereumAddress.fromHex(account!);
  }

  WalletConnectEthereumCredentials getCredentials() {
    return credentials;
  }

  Web3Client getClient() {
    return client;
  }
}
