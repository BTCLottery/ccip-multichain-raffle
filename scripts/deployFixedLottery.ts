import hre from 'hardhat'
import mumbaiConfig from '../verify/testnet/mumbaiConfig'
import { ethers } from "hardhat";
import { Contract } from 'ethers';
import { saveInfo, readYaml, sleep } from "../utils/saveContractYAML";
import { ConfigType } from "../utils/types/deployerConfig";

async function main() {
  const [owner] = await ethers.getSigners();
  const network = await hre.network.name;
  console.log('owner', owner.address)
  console.log('mumbaiConfig', mumbaiConfig)

  let BTCLPCore: Contract;
  let MultichainLottery: Contract;
  let config: ConfigType

  if(network === "polygonMumbai") {
    config = mumbaiConfig;
  } else {
    console.error("Unsupported Network")
    return;
  }

  const BTCLPCoreAddress: string = readYaml(`BTCLPCore`, network)
  BTCLPCore = await ethers.getContractAt('BTCLPCore', BTCLPCoreAddress);

  let MultichainLotteryFactory = await ethers.getContractFactory('MultichainLottery', {
    libraries: { BTCLPCore: BTCLPCore.address }
  })

  MultichainLottery = await MultichainLotteryFactory.connect(owner).deploy(...config)
  await MultichainLottery.deployed()
  console.log('MultichainLottery', MultichainLottery.address)
  
  saveInfo(`Fixed_Duel_2Players_1W_MUMBAI_TESTNET`, network, MultichainLottery.address)

  await sleep(35000);
  
  await hre.run("verify:verify", {
    address: MultichainLottery.address,
    libraries: {
      BTCLPCore: BTCLPCore.address
    },
    constructorArguments: mumbaiConfig,
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
