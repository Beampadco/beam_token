const BullionTribe = artifacts.require("BullionTribe");

module.exports = async function (deployer) {
  const accounts = await web3.eth.getAccounts();
  console.log(accounts[0]);
  await deployer.deploy(BullionTribe, "Bullion Tribe Mint Pass", "PASS", {
    from: accounts[0],
    overwrite: true,
  });

  // await deployer.deploy(BullionTribe, "Bullion Tribe", "TRIBE", {
  //   from: accounts[0],
  //   overwrite: true,
  // });
};
