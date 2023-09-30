import { ethers } from "hardhat";
import { Contract } from 'ethers';
import { saveInfo, sleep } from "../utils/saveContractYAML"
import hre from 'hardhat'

async function main() {
  const [owner] = await ethers.getSigners();
  const network = await hre.network.name;
  const balance = await owner.getBalance()
  console.log('owner', owner.address)
  console.log('network', network)
  console.log('balance', balance)

  let BTCLCore: Contract;
  let BTCLCoreFactory = await ethers.getContractFactory('BTCLCore');
  BTCLCore = await BTCLCoreFactory.connect(owner).deploy();
  await BTCLCore.deployed();

  console.log("BTCLCore.address", BTCLCore.address)

  saveInfo('BTCLCore', network, BTCLCore.address)

  await sleep(15000);

  await hre.run("verify:verify", {
    address: BTCLCore.address,
    constructorArguments: []
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
