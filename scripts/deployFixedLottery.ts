import { ethers } from "hardhat";
import { Contract } from 'ethers';
import hre from 'hardhat'
import mumbaiConfig from '../verify/testnet/mumbaiConfig'
import maticConfig from '../verify/mainnet/maticConfig'
import { saveInfo, readYaml, sleep } from "../utils/saveContractYAML";
import { ConfigType } from "../utils/types/deployerConfig";

async function main() {
  const [owner] = await ethers.getSigners();
  const network = await hre.network.name;
  console.log('owner', owner.address)
  console.log('mumbaiConfig', mumbaiConfig)

  let BTCLCore: Contract;
  let BTCLFixedLottery: Contract;
  let config: ConfigType

  if(network === "polygonMumbai") {
    config = mumbaiConfig;
  } else if(network === "polyMainnet") {
    config = maticConfig;
  } else {
    console.error("Unsupported Network")
    return;
  }

  const BTCLCoreAddress: string = readYaml(`BTCLCoreFixed`, network)
  BTCLCore = await ethers.getContractAt('BTCLCoreFixed', BTCLCoreAddress);

  let BTCLFixedLotteryFactory = await ethers.getContractFactory('BTCLFixedLottery', {
    libraries: { BTCLCore: BTCLCore.address }
  })

  BTCLFixedLottery = await BTCLFixedLotteryFactory.connect(owner).deploy(...config)
  await BTCLFixedLottery.deployed()
  console.log('BTCLFixedLottery', BTCLFixedLottery.address)
  
  saveInfo(`Fixed_Duel_20P_4W_MUMBAI_TESTNET`, network, BTCLFixedLottery.address)

  await sleep(35000);
  
  await hre.run("verify:verify", {
    address: BTCLFixedLottery.address,
    libraries: {
      BTCLCore: BTCLCore.address
    },
    constructorArguments: mumbaiConfig,
  });

  await BTCLFixedLottery.connect(owner).transferOwnership("0xC42c57eD3aE399Cf564A207b7d5321cA7F424239");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
