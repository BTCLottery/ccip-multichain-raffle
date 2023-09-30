import { network } from 'hardhat'

// Impersonate account and top-up balances on the local mainnet fork
export async function impersonateAccount (provider:any, addr:string) {
    try {
        await provider.send("hardhat_impersonateAccount", [addr]);
        await provider.getSigner(addr);
        await network.provider.request({ method: "hardhat_impersonateAccount", params: [addr] });
        await provider.send("hardhat_setBalance", [addr, "0x152D02C7E14AF6800000"]);
        return await provider.getSigner(addr);
    } catch (error) {
        console.log('error', error)
    }
}