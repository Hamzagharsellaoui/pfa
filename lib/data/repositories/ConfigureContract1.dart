import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

// --- Doctor Info Class ---
// Helper class to hold doctor details retrieved from the contract
class DoctorInfo {
  final EthereumAddress address;
  final String name;

  DoctorInfo({required this.address, required this.name});

  @override
  String toString() {
    return 'DoctorInfo(name: $name, address: ${address.hex})';
  }
}

//consultations functions!

// --- Blockchain Connection Configuration ---
class ConfigureBlockchainConnection {
  final String rpcUrl;
  final EthPrivateKey privateKey;

  ConfigureBlockchainConnection(String rpc, String key)
    : rpcUrl = rpc,
      privateKey = EthPrivateKey.fromHex(key);

  String getRpc() => rpcUrl;
}

// --- Contract Configuration & Interaction ---
class ConfigureContract {
  final ConfigureBlockchainConnection conn;
  final String abi;
  final String contractAddress;
  late final Web3Client client;
  late final EthPrivateKey privateKey;
  late final DeployedContract deployedContract;

  /// Default constructor: no parameters needed, uses preconfigured values
  ConfigureContract.auto()
    : conn = ConfigureBlockchainConnection(
        "https://sepolia.infura.io/v3/2ac8ee3b494048d69c4d7dd360468286",
        "5556982aca174196667b94d39decf39dc7ed8dc6987236768ec433487293d1f3",
      ),
      abi = '''[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_address",
				"type": "address"
			}
		],
		"name": "addDoctor",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_doctorAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"name": "addDoctorName",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "addPatient",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_patientAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"name": "addPatientName",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_doctorAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_dateTime",
				"type": "uint256"
			}
		],
		"name": "bookConsultation",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_consultationId",
				"type": "uint256"
			}
		],
		"name": "cancelConsultation",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_consultationId",
				"type": "uint256"
			}
		],
		"name": "confirmConsultation",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "ConsultationCanceled",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "ConsultationConfirmed",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "ConsultationFinished",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "patient",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "doctor",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "dateTime",
				"type": "uint256"
			}
		],
		"name": "ConsultationRequested",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			}
		],
		"name": "ConsultationStarted",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_consultationId",
				"type": "uint256"
			}
		],
		"name": "finishConsultation",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_consultationId",
				"type": "uint256"
			}
		],
		"name": "startConsultation",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "consultations",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "patient",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "doctor",
				"type": "address"
			},
			{
				"internalType": "enum ConsultationContract.ConsultationStatus",
				"name": "status",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "doctors",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "addressDoctor",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAllDoctorAddresses",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_consultationId",
				"type": "uint256"
			}
		],
		"name": "getConsultation",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "patientName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "doctorName",
				"type": "string"
			},
			{
				"internalType": "enum ConsultationContract.ConsultationStatus",
				"name": "status",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_doctorAddress",
				"type": "address"
			}
		],
		"name": "getConsultationHistoryDoctor",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_patientAddress",
				"type": "address"
			}
		],
		"name": "getConsultationHistoryPatient",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_doctorAddress",
				"type": "address"
			}
		],
		"name": "getDoctorName",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_patientAddress",
				"type": "address"
			}
		],
		"name": "getPatientName",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "patients",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "addressPatient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "NFTMedicalRecord",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "tokenBalance",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]''',
      contractAddress = "0x7e01Fc8F359389f82336325d3552Ef6b36a04cf7" {
    client = Web3Client(conn.getRpc(), Client());
    privateKey = conn.privateKey;
    _deployContract();
  }

  // Original constructor, kept for custom initialization if needed
  ConfigureContract(this.conn, this.abi, this.contractAddress) {
    client = Web3Client(conn.getRpc(), Client());
    privateKey = conn.privateKey;
    _deployContract();
  }

  // Load the contract using its ABI and deployed address.
  void _deployContract() {
    deployedContract = DeployedContract(
      ContractAbi.fromJson(abi, "ConsultationContract"),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  // ... (rest of your methods unchanged) ...
  // Add a new patient
  Future<String> addPatient() async {
    final function = deployedContract.function("addPatient");
    final credentials = privateKey; // Use credentials directly
    final transaction = Transaction.callContract(
      contract: deployedContract,
      function: function,
      parameters: [],
      from: credentials.address, // Use address from credentials
    );
    // Consider adding gas parameters if needed: maxGas, gasPrice/maxFeePerGas
    return await client.sendTransaction(
      credentials,
      transaction,
      chainId: 11155111,
    ); // Sepolia chainId
  }

  // Add a new doctor
  Future<String> addDoctor(EthereumAddress doctorAddress) async {
    final function = deployedContract.function("addDoctor");
    final credentials = privateKey;
    final transaction = Transaction.callContract(
      contract: deployedContract,
      function: function,
      parameters: [doctorAddress],
      from: credentials.address,
    );
    return await client.sendTransaction(
      credentials,
      transaction,
      chainId: 11155111,
    );
  }

  // Book a consultation
  Future<String> bookConsultation(
    EthereumAddress doctorAddress,
    BigInt timestamp,
  ) async {
    final function = deployedContract.function("bookConsultation");
    final credentials = privateKey;
    final transaction = Transaction.callContract(
      contract: deployedContract,
      function: function,
      parameters: [doctorAddress, timestamp],
      from: credentials.address,
    );
    return await client.sendTransaction(
      credentials,
      transaction,
      chainId: 11155111,
    );
  }

  /// Get all consultation IDs of a patient
  /// Returns Future<List<BigInt>>
  Future<List<dynamic>> getConsultationHistoryPatient(
    String patientAddress,
  ) async {
    final address = EthereumAddress.fromHex(patientAddress);
    final getHistoryFunction = deployedContract.function(
      "getConsultationHistoryPatient",
    );

    // client.call returns Future<List<dynamic>> which might be [[id1, id2, ...]]
    List<dynamic> result = await client.call(
      contract: deployedContract,
      function: getHistoryFunction,
      params: [address],
    );

    // Assuming the function returns a single array (uint256[]), it will be the first element.
    // Ensure the result is not empty and the first element is a list.
    if (result.isNotEmpty && result[0] is List) {
      print(result);
      // Directly return the list of IDs (which should be BigInts)
      return result[0];
    }
    return []; // Return empty list if format is unexpected
  }

  /// Get details of a specific consultation by ID
  /// Returns Future<List<dynamic>> containing [patientAddr, doctorAddr, timestamp, status, ...]
  Future<List<dynamic>> getConsultation(BigInt consultationId) async {
    final getConsultationFunction = deployedContract.function(
      "getConsultation",
    );

    // client.call returns Future<List<dynamic>> containing all return values
    List<dynamic> result = await client.call(
      contract: deployedContract,
      function: getConsultationFunction,
      params: [consultationId],
    );

    // *** FIX: Return the entire list of results, not just the first element ***
    return result;
  }

  /// Get all consultations details of a patient
  /// Returns Future<List<List<dynamic>>> where each inner list contains details of one consultation
  Future<List<List<dynamic>>> getAllConsultationsOfPatient(
    String patientAddress,
  ) async {
    // This returns Future<List<dynamic>> which resolves to List<BigInt>
    List<dynamic> consultationIds = await getConsultationHistoryPatient(
      patientAddress,
    );
    List<List<dynamic>> consultations =
        []; // Explicitly type as List<List<dynamic>>

    // Ensure consultationIds is actually a list of BigInts before iterating
    // Convert dynamic list items to BigInt safely
    List<BigInt> typedIds = consultationIds.whereType<BigInt>().toList();

    for (BigInt id in typedIds) {
      // Iterate through BigInt IDs
      // This returns Future<List<dynamic>> which resolves to the details list
      List<dynamic> consultationDetails = await getConsultation(id);
      consultations.add(consultationDetails); // Add the list of details
    }

    return consultations;
  }

  // --- Helper functions (Keep as they are, assuming they work) ---

  Future<String> getDoctorName(String doctorAddress) async {
    final address = EthereumAddress.fromHex(doctorAddress);
    final getDoctorNameFunction = deployedContract.function('getDoctorName');
    final result = await client.call(
      contract: deployedContract,
      function: getDoctorNameFunction,
      params: [address],
    );
    // Assuming getDoctorName returns a single string value
    return result.isNotEmpty ? result[0] as String : "Unknown Doctor";
  }

  Future<String> getPatientName(String patientAddress) async {
    final address = EthereumAddress.fromHex(patientAddress);
    // *** BUG FIX: You were calling getDoctorName function here! ***
    final getPatientNameFunction = deployedContract.function(
      'getPatientName',
    ); // Assuming you have this function in Solidity
    if (getPatientNameFunction == null) {
      print("Error: getPatientName function not found in ABI.");
      return "Unknown Patient (ABI Error)";
    }

    final result = await client.call(
      contract: deployedContract,
      function: getPatientNameFunction, // Use the correct function
      params: [address],
    );
    return result.isNotEmpty ? result[0] as String : "Unknown Patient";
  }

  Future<String> addPatientName(String name) async {
    // Assumes adding name for the current user (privateKey holder)
    final function = deployedContract.function("addPatientName");
    final tx = Transaction.callContract(
      contract: deployedContract,
      function: function,
      parameters: [privateKey.address, name],
      from: privateKey.address,
    );
    return await client.sendTransaction(privateKey, tx, chainId: 11155111);
  }

  // --- NEW Method to get all doctors ---
  Future<List<DoctorInfo>> getAllDoctors() async {
    final List<DoctorInfo> doctorsList = [];
    final getAddressesFunction = deployedContract.function(
      'getAllDoctorAddresses',
    );

    // 1. Get all doctor addresses
    final List<dynamic> results = await client.call(
      contract: deployedContract,
      function: getAddressesFunction,
      params: [],
    );

    if (results.isNotEmpty && results[0] is List) {
      List<dynamic> addressesRaw =
          results[0]; // This should be List<EthereumAddress>
      List<EthereumAddress> doctorAddresses =
          addressesRaw.whereType<EthereumAddress>().toList();

      // 2. For each address, get the name (can be slow if many doctors)
      for (EthereumAddress address in doctorAddresses) {
        try {
          String name = await getDoctorName(address.hex);
          doctorsList.add(
            DoctorInfo(
              address: address,
              name: name.isEmpty ? "Name Not Set" : name,
            ),
          );
        } catch (e) {
          print("Error getting name for doctor ${address.hex}: $e");
          doctorsList.add(
            DoctorInfo(address: address, name: "Error Fetching Name"),
          ); // Add with error indication
        }
      }
    }
    return doctorsList;
  }
  // --
}
