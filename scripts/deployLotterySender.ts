import { ethers } from "hardhat";
import hre from 'hardhat'
import fujiLotterySenderConfig from '../verify/testnet/fujiLotterySenderConfig'
import { saveInfo, readYaml, sleep } from "../utils/saveContractYAML";

async function main() {
    const [owner] = await ethers.getSigners();
    const network = await hre.network.name;
    console.log('owner', owner.address)
    console.log('fujiLotterySenderConfig', fujiLotterySenderConfig)

    if(network !== `avalancheFuji`) {
        console.error(`❌ Must be called from Avalanche Fuji`);
        return 1;
    }

    const MultichainLotteryAddress: string = readYaml(`MultichainLottery`, "polygonMumbai")

    const FujiCCIPRouter = `0x554472a2720E5E7D5D3C817529aBA05EEd5F82D8`;
    const FujiLinkToken = `0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846`;
    const receiver = MultichainLotteryAddress;
    const ccipBnMAddress = `0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4`;
    const amount = 110000000000000000n; // 0.11 Bnm
    const destinationChainSelector = 12532609583862916517; // mumbai chain selector

    const ccipTokenSenderFactory = await ethers.getContractFactory("LotterySender");
    const ccipTokenSender = await ccipTokenSenderFactory.deploy(FujiCCIPRouter, FujiLinkToken);

    saveInfo(`Fixed_Duel_2Players_1W_MUMBAI_TESTNET`, network, MultichainLotteryAddress)

    await sleep(35000);
    
    await hre.run("verify:verify", {
        address: MultichainLotteryAddress,
        constructorArguments: fujiLotterySenderConfig
    });

    const whitelistTx = await ccipTokenSender.whitelistChain(
        destinationChainSelector
    );

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
  