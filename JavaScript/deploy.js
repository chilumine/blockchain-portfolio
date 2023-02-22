// $ npx hardhat node
// $ npx hardhat run scripts/deploy.js
// deploy with hardhat, simple version

const hre = require("hardhat");

async function main() {
  const Contract = await hre.ethers.getContractFactory("Contract");
  const contract = await Contract.deploy();

  await contract.deployed();

  console.log(
    `Contract deployed to ${contract.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});