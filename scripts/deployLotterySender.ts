import { ethers } from "hardhat";
import hre from "hardhat";
import fujiLotterySenderConfig from "../verify/testnet/fujiLotterySenderConfig";
import { saveInfo, readYaml, sleep } from "../utils/saveContractYAML";

async function main() {
  const [owner] = await ethers.getSigners();
  const network = await hre.network.name;
  console.log("owner", owner.address);
  console.log("fujiLotterySenderConfig", fujiLotterySenderConfig);

  if (network !== `fuji`) {
    console.error(`❌ Must be called from Avalanche Fuji`);
    return 1;
  }

  // const MultichainLotteryAddress: string = readYaml(`MultichainLottery`, "polygonMumbai")

  const FujiCCIPRouter = `0x554472a2720E5E7D5D3C817529aBA05EEd5F82D8`;
  const FujiLinkToken = `0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846`;
  const receiver = `0x973f1dA88f28d9C5DBd73654865D261443a83f0F`;// `0xD0d2779b2c1CCd0eBbDA723Ae464E87C749Dd9C5`;
  const ccipBnMAddress = `0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4`;
  const amount = 110000000000000000n; // 0.11 Bnm
  const destinationChainSelector = "12532609583862916517"; // mumbai chain selector

  const ccipTokenSenderFactory = await ethers.getContractFactory(
    "LotterySender"
  );
  const ccipTokenSender = await ccipTokenSenderFactory.deploy(
    FujiCCIPRouter,
    FujiLinkToken
  );

  console.log("test1");
  saveInfo(`LotterySender`, network, ccipTokenSender.address);
  console.log("test2");

  await sleep(35000);
  console.log("test3");

  await hre.run("verify:verify", {
    address: ccipTokenSender.address,
    constructorArguments: fujiLotterySenderConfig,
  });
  console.log("test4");

  const whitelistTx = await ccipTokenSender.whitelistChain(
    destinationChainSelector
  );
  console.log("test5");

  console.log(`Whitelisted Sepolia, transaction hash: ${whitelistTx.hash}`);

  const transferTx = await ccipTokenSender.transferTokens(
    destinationChainSelector,
    receiver,
    ccipBnMAddress,
    amount
  );

  console.log(`CCIP transaction hash: ${transferTx.hash}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
