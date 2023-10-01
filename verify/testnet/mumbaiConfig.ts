import { ConfigType } from "../../utils/types/deployerConfig";

const subsId = 2928 // https://vrf.chain.link/mumbai/2928

// module.exports = [
const mumbaiConfig: ConfigType = [
    "0x70499c328e1E2a3c41108bd3730F6670a44595D1", // address _router
    "0xf1E3A5842EeEF51F2967b3F05D45DD4f4205FF40", // address _whitelistedToken
    "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed", // address _coordinatorAddress,
    "0x326c977e6efc84e512bb9c30f76e30c160ed06fb", // address _linkToken,
    2, // max players per round,
    "100000000000000000", // ticket price
    "10000000000000000", // ticket fee
    subsId, // uint64 _subscriptionId
];

export default mumbaiConfig