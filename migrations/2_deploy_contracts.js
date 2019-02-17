var EcommerceStore = artifacts.require("./EcommerceStore.sol");
const get3rdAccount = async () => {
  const accounts = await web3.eth.getAccounts()
  return accounts[3]
}

module.exports = function(deployer) {
  deployer.deploy(EcommerceStore, get3rdAccount());
};
