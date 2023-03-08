const Beam_Token = artifacts.require("Beam_Token");

module.exports = async function (deployer) {
  const accounts = await web3.eth.getAccounts();
  console.log(accounts[0]);
  await deployer.deploy(Beam_Token, { from: accounts[0], overwrite: true });
};
