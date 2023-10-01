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

  let BTCLPCore: Contract;
  let BTCLPCoreFactory = await ethers.getContractFactory('BTCLPCore');
  BTCLPCore = await BTCLPCoreFactory.connect(owner).deploy();
  await BTCLPCore.deployed();

  console.log("BTCLPCore.address", BTCLPCore.address)

  saveInfo('BTCLPCore', network, BTCLPCore.address)

  await sleep(15000);

  await hre.run("verify:verify", {
    address: BTCLPCore.address,
    constructorArguments: []
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
