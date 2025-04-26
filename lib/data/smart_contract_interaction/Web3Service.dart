import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';

import 'WalletService.dart';
import 'metamask_service.dart';

class Web3Service {
  static const String consultationContractAddress = '0xD3cAb36B7CFF6d1EEeDa3fFf1a1413C86760ba7C';
  late final String rpcUrl;

  late final WalletService _walletService;
  late final Web3Client _client;
  late final DeployedContract _contract;
  late final ContractFunction _bookConsultationFunction;

  Web3Service({required String rpcUrl}) : rpcUrl = rpcUrl {
    _walletService = WalletService();
  }

  Future<void> initContract() async {
    // Initialize client
    _client = Web3Client(rpcUrl, Client());

    // Load contract ABI
    final abi = await _loadAbi();
    _contract = DeployedContract(
      abi,
      EthereumAddress.fromHex(consultationContractAddress),
    );

    // Get contract functions
    _bookConsultationFunction = _contract.function('bookConsultation');
  }

  Future<ContractAbi> _loadAbi() async {
    // Load ABI from file
    final abiString = await rootBundle.loadString('assets/contract_abi.json');
    return ContractAbi.fromJson(abiString, 'ConsultationContract');
  }

  Future<void> connectWallet({
    required String appName,
    required String appDescription,
    required String appUrl,
    required String appIcon, required String rpcUrl,
  }) async {
    await _walletService.connect(
      appName: appName,
      appDescription: appDescription,
      appUrl: appUrl,
      appIcon: appIcon,
      rpcUrl: rpcUrl,
    );
  }

  Future<String> bookConsultation({
    required String doctorAddress,
    required int dateTime,
    required String description,
  }) async {
    if (!_walletService.isConnected) {
      throw Exception('Wallet not connected');
    }

    final tx = Transaction.callContract(
      contract: _contract,
      function: _bookConsultationFunction,
      parameters: [
        EthereumAddress.fromHex(doctorAddress),
        BigInt.from(dateTime),
        description,
      ],
    );

    return await _walletService.signTransaction(tx);
  }

  Future<String?> getCurrentAddress() async {
    return (await _walletService.getAddress())?.hex;
  }

  Future<void> disconnectWallet() async {
    await _walletService.disconnect();
  }
}