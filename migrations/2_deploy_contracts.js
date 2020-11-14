var EcoToken = artifacts.require("EcoToken");
var EcoExchange = artifacts.require("EcoExchange");

module.exports = function (deployer) {
    deployer.deploy(EcoToken, 10000).then(function() {
        return deployer.deploy(EcoExchange, "ExchangeMarket", EcoToken.address);
    });
};