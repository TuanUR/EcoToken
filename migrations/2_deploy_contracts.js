var BavariaEcoToken = artifacts.require("BavariaEcoToken");
var EcoExchange = artifacts.require("EcoExchange");

module.exports = function (deployer) {
    deployer.deploy(BavariaEcoToken, 100000000000).then(function() {
        return deployer.deploy(EcoExchange, "ExchangeMarket", BavariaEcoToken.address);
    });
};