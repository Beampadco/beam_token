const BullionTribe = artifacts.require("BullionTribe");

module.exports = async function (deployer) {
  const accounts = await web3.eth.getAccounts();
  console.log(accounts[0]);
  await deployer.deploy(BullionTribe, { from: accounts[0], overwrite: true });
};
