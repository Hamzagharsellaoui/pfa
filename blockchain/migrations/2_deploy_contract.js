const ConsultationContract = artifacts.require("ConsultationContract");
const MyToken = artifacts.require("MyToken");

module.exports = async function (deployer, network, accounts) {
  // Use the first account as owner if not specified
  const initialOwner = accounts[0];
  const initialSupply = 1000;

  // Deploy with increased gas limit
  await deployer.deploy(
    MyToken,
    initialOwner,
    initialSupply,
    { gas: 5000000 } // Increased gas limit
  );

  await deployer.deploy(ConsultationContract);
};