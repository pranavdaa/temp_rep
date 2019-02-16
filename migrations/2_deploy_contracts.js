var EcommerceStore = artifacts.require("./EcommerceStore.sol");

module.exports = function(deployer) {
  deployer.deploy(EcommerceStore,'0x8604f3d63c27dffa9a908641add497df976aa714' );
};
