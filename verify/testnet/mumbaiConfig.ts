import { ConfigType } from "../../utils/types/deployerConfig";

const subsId = 2928 // https://vrf.chain.link/mumbai/2928

// const currentTimestampInSeconds = Math.round(Date.now() / 1000);
const keyHash = "0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f";

// module.exports = [
const mumbaiConfig: ConfigType = [
    "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed", // address _coordinatorAddress,
    "0x326c977e6efc84e512bb9c30f76e30c160ed06fb", // address _linkToken,
    20, // players,
    "5000000000000000", // ticket price
    "500000000000000", // ticket fee
    4, // number of winners
    subsId, // uint64 _subscriptionId,
    2500000, // uint32 _callbackGasLimit,
    3, // uint16 _requestConfirmations
    keyHash, // bytes32 _keyHash
    false, // paused
];

export default mumbaiConfig