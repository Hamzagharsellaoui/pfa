import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

import 'metamask_service.dart';


class WalletService {
  late WalletConnect connector;
  late EthereumWalletConnectProvider provider;
  late WalletConnectEthereumCredentials credentials;
  late Web3Client client;
  late String account;
  bool isConnected = false;

  Future<void> connect({
    required String appName,
    required String appDescription,
    required String appUrl,
    required String appIcon,
    required String rpcUrl,
  }) async {
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: appName,
        description: appDescription,
        url: appUrl,
        icons: [appIcon],
      ),
    );

    final session = await connector.createSession(
      chainId: 5,
      onDisplayUri: (uri) async {
        await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
      },
    );

    account = session.accounts.first;
    provider = EthereumWalletConnectProvider(connector);
    credentials = WalletConnectEthereumCredentials(provider: provider);
    client = Web3Client(rpcUrl, Client());
    isConnected = true;
  }

  Future<EthereumAddress?> getAddress() async {
    if (!isConnected) return null;
    return EthereumAddress.fromHex(account);
  }

  Future<String> signTransaction(Transaction transaction) async {
    return await client.sendTransaction(credentials, transaction);
  }

  Future<void> disconnect() async {
    await connector.killSession();
    isConnected = false;
  }
}
