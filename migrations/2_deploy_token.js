const EmbraceCards = artifacts.require("EmbraceCards");

module.exports = async function (deployer) {
  // Price will be 0.05eth
  await deployer.deploy(EmbraceCards, "BASE_URI", 10000, 20, 5000000000000000);
};
