export type ConfigType = [
    string,  // _coordinatorAddress
    string,  // _linkToken
    number,  // players
    string,  // ticket price
    string,  // ticket fee
    number,  // number of winners
    number,  // _subscriptionId
    number,  // _callbackGasLimit
    number,  // _requestConfirmations
    string,  // _keyHash
    boolean, // _paused
];

export type CustomChainlinkConfigType = [
    string, // address _coordinatorAddress,
    string, // address _linkToken,
    number, // uint64 _subscriptionId,
    number, // uint32 _callbackGasLimit,
    number, // uint16 _requestConfirmations
    string, // bytes32 _keyHash
]

export type CustomConfigType = [
    number,  // _maxPlayers
    string,  // _ticketPrice
    string,  // _ticketFee
    number,  // _totalWinners
    number,  // _minPlayers
    number,  // _minutesUntilDraw
    boolean, // _paused
]

export type CombinedCustomConfigType = [
    string, // address _coordinatorAddress,
    string, // address _linkToken,
    number, // uint64 _subscriptionId,
    number, // uint32 _callbackGasLimit,
    number, // uint16 _requestConfirmations
    string, // bytes32 _keyHash
    number,  // _maxPlayers
    string,  // _ticketPrice
    string,  // _ticketFee
    number,  // _totalWinners
    number,  // _minPlayers
    number,  // _minutesUntilDraw
    boolean, // _paused
]