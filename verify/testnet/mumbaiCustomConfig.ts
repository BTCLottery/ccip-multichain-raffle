import { CombinedCustomConfigType, CustomChainlinkConfigType, CustomConfigType } from "../../utils/types/deployerConfig";

const subsId = 2928 // https://vrf.chain.link/mumbai/2928

// const currentTimestampInSeconds = Math.round(Date.now() / 1000);
const keyHash = "0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f";

// Define your Chainlink configuration and other parameters
const chainlinkConfig: CustomChainlinkConfigType = [
    "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed", // address _coordinatorAddress,
    "0x326c977e6efc84e512bb9c30f76e30c160ed06fb", // address _linkToken,
    subsId, // uint64 _subscriptionId,
    2500000, // uint32 _callbackGasLimit,
    3, // uint16 _requestConfirmations
    keyHash, // bytes32 _keyHash
];

// module.exports = [
const gameConfig: CustomConfigType = [
    2, // _maxPlayers,
    "5000000000000000", // _ticketPrice
    "500000000000000", // _ticketFee
    1, // _totalWinners
    0, // _minPlayers
    0, // _minutesUntilDraw
    false, // paused
];

// const mumbaiConfig = [chainlinkConfig, ...gameConfig];

const mumbaiConfig: CombinedCustomConfigType = [
    ...chainlinkConfig, 
    ...gameConfig
  ];

export default mumbaiConfig