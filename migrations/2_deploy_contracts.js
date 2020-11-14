var EcoToken = arifacts.require("EcoToken");
var EcoExchange = artifacts.require("EcoExchange");
var accounts = web3.eth.getAcounts();
var owner = accounts[0];

module.exports = function (deployer) {
  deployer.deploy(EcoToken, 10000, {from: owner}).then(function() {
      return deployer.deploy(EcoExchange, "MunichExchangeMarket", EcoToken.address, owner);
  });
};
