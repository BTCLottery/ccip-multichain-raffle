// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AutomationCompatible} from "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";
import {AutomatedRandomness} from "./extended/AutomatedRandomness.sol";
import {BTCLPCore} from "./libraries/BTCLPCore.sol";
import {LotterySender} from "./LotterySender.sol";
import {LotteryReceiver} from "./LotteryReceiver.sol";

/**
 * @title v1.0 Beta Version
 * @notice Website: https://btclottery.io
 * @dev This contract utilises Chainlink Verifiable Random Function (VRF) + Automation Keeper Subscription for trustlesness
 * @dev This contract is an immutable EVM Raffle Game with a fixed and unchangeable configuration that was set on deployment
 */
contract MultichainLottery is
    AutomationCompatible,
    AutomatedRandomness,
    ReentrancyGuard,
    LotteryReceiver,
    LotterySender
{
    /* ============ Global Variables ============ */
    using SafeERC20 for IERC20;

    // Mapping the details of each round
    mapping(uint256 => BTCLPCore.Round) public rounds;

    // Round configuration
    uint256 public round;
    uint256 public immutable ticketPrice;
    uint256 public immutable ticketFee;
    uint256 public immutable maxPlayers;
    uint256 public constant totalWinners = 1;

    /**
     * @dev CCIP Multichain Raffle
     */
    constructor(
        address _ccipReceiveRouter,
        address _ccipSendRouter,
        address _whitelistedToken,
        address _coordinator,
        address _linkToken,
        uint256 _maxPlayers,
        uint256 _ticketPrice,
        uint256 _ticketFee,
        uint64 _subscriptionId
    )
        AutomatedRandomness(_coordinator, _linkToken, _subscriptionId)
        LotteryReceiver(_ccipReceiveRouter)
        LotterySender(_ccipSendRouter, _linkToken)
    {
        // Initialize the round number to 1
        round = 1;
        // Set the status of the first round to open
        rounds[round].status.roundStatus = BTCLPCore.Status.Open;
        // Set max players
        maxPlayers = _maxPlayers;
        // Set ticket price
        ticketPrice = _ticketPrice;
        // Set ticket fee
        ticketFee = _ticketFee;
        // Whitelisted ERC20 Token
        whitelistedToken = IERC20(_whitelistedToken);
        // Emit first round event
        emit BTCLPCore.LotteryOpened(round);
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) 
        internal
        onlyWhitelistedSourceChain(message.sourceChainSelector)
        onlyWhitelistedSenders(abi.decode(message.sender, (address))) 
        override 
    {
        require(message.destTokenAmounts[0].amount == ticketPrice + ticketFee, "Not enough CCIP-BnM to purchase 1 ticket");
        (bool success, ) = address(this).call(message.data);
        require(success);
    }

    /**
     * @dev Function that allows players to purchase 1 ticket per address
     * @notice If high demand or spammed, players will end up purchasing tickets in future rounds
     */
    function buyTicketCCIP(address _player, uint64 _chainSelector, uint256 _amount) private returns (uint256 roundNr) {
        return purchaseTickets(selectRound(_player), _player, _amount, _chainSelector);
    }

    function buyTicket(uint256 _amount) public returns (uint256 roundNr) {
        return purchaseTickets(selectRound(msg.sender), msg.sender, _amount, 0); // if set to 0 means it's on chain A
    }

    /**
     * @dev Find available tickets in current or future rounds
     */
    function selectRound(address _player) private view returns (uint256) {
        uint256 currentRound = round;
        while (rounds[currentRound].status.totalBets >= maxPlayers || rounds[currentRound].contributed[_player] > 0)
        {
            currentRound++;
        }
        return currentRound;
    }

    function purchaseTickets(uint256 _roundNr, address _player, uint256 _amount, uint64 _chainSelector) private returns (uint256 roundNumber) {

        // Check if the lottery is paused and that there is a new round, if yes, revert the transaction
        if (paused == true && rounds[_roundNr].status.totalBets == 0) revert BTCLPCore.LOTTERY_PAUSED();

        // Check if the round is open, if not, revert the transaction
        if (rounds[_roundNr].status.roundStatus != BTCLPCore.Status.Open) revert BTCLPCore.TRANSFER_FAILED();

        // Check if the MATIC provided is equal to ticket price plus fee exactly
        if (_amount != ticketPrice + ticketFee) revert BTCLPCore.TRANSFER_FAILED();

        // Check if already bought a ticket in the current round
        if (rounds[_roundNr].contributed[_player] > 0) revert BTCLPCore.TRANSFER_FAILED();

        // Transfer to the contract the ERC20 Bnm Tokens
        whitelistedToken.transferFrom(_player, address(this), _amount);

        // Set Contribution amount
        rounds[_roundNr].contributed[_player] = _amount;

        // get next bet id and current last ticket index
        uint256 nextBetID = rounds[_roundNr].status.totalBets + 1;
        uint32 lastIndex = getLastBetID(_roundNr, rounds[_roundNr].status.totalBets);

        // sets the purchaser address + ccip selector + ticket amount for the next bet
        setPackedValue(_roundNr, nextBetID, _player, _chainSelector, lastIndex + 1);

        uint256 totalTickets = rounds[_roundNr].status.totalTickets + (_amount - ticketFee);

        // increment the total bets and total tickets of the round
        rounds[_roundNr].status.totalBets = nextBetID;
        rounds[_roundNr].status.totalTickets = totalTickets;

        // emit event to log the purchase
        emit BTCLPCore.TicketsPurchased(_roundNr, _player, _amount, nextBetID, totalTickets);
        return _roundNr;
    }


    /* ============ External Functions ============ */
    /**
     * @dev param calldata the calldata which is used to determine the type of upkeep.
     * @return upkeepNeeded true if and only if at least max players have joined the round.
     * @return performData the data that needs to be performed based on calldata type.
     */
    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = BTCLPCore.checkUpkeepVRF(
            rounds[round].status.roundStatus, rounds[round].status.requestId, rounds[round].status.totalBets, maxPlayers
        );
        performData = abi.encode(round);
    }

    /**
     * @notice Requests randomness from the VRF coordinator
     */
    function performUpkeep(bytes calldata performData) external override {
        // Check if the function is being called at the correct time
        bool reqRandomness = BTCLPCore.checkUpkeepVRF(
            rounds[round].status.roundStatus, rounds[round].status.requestId, rounds[round].status.totalBets, maxPlayers
        );

        // Decode the performData to retrieve the round number, winningBetID, and userAddress
        (uint256 _round) = abi.decode(performData, (uint256));

        // Check if the function is being called with the correct parameters
        if (round != _round) revert BTCLPCore.UPKEEP_FAILED();
        if (rounds[round].status.roundStatus != BTCLPCore.Status.Open) revert BTCLPCore.UPKEEP_FAILED();

        // Check if we need to request randomness
        if (reqRandomness) {
            rounds[round].status.roundStatus = BTCLPCore.Status.Drawing;
            rounds[round].status.requestId = requestRandomness(uint32(totalWinners));
            emit BTCLPCore.LotteryClosed(round, rounds[round].status.totalTickets, rounds[round].status.totalBets);
        }
    }

    uint public test = 0;
    /**
     * @notice Requests randomness from the VRF coordinator and save the random numbers in the draw
     * @param requestId the VRF V2 request ID, provided at request time.
     * @param randomness the randomness provided by Chainlink VRF.
     */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomness) internal override {
        // Check if the request ID matches with the request ID of the current round
        if (rounds[round].status.requestId != requestId) revert BTCLPCore.INVALID_VRF_REQUEST();

        // Change the status of the round from Drawing and save winning VRF randomness
        rounds[round].status.roundStatus = BTCLPCore.Status.Completed;
        rounds[round].status.requestId = requestId;
        rounds[round].status.randomness = randomness[0];

        // IF CCIP WINNER SEND HIS PRIZE BACK TO HIS SOURCE CHAIN
        (address luckyWinner, uint64 sourceChainSelector, uint256 luckyPrize) = calculateWinner(round);

        // LOCAL TRANSFER BNM TOKENS TO WINNER ON CHAIN A
        if (sourceChainSelector == 0) {
            BTCLPCore.distributionHelper(address(whitelistedToken), luckyWinner, luckyPrize);
            test = 1;
        }
        
        // CCIP TRANSFER BNM TOKENS TO WINNER ON CHAIN B
        if (sourceChainSelector > 0) {
            transferTokensCCIP(sourceChainSelector, luckyWinner, address(address(whitelistedToken)), luckyPrize);
            test = 2;
        }

        rounds[round].winnerClaimed[luckyWinner] == true;   

        // Set next round
        round = round + 1;
        rounds[round].status.roundStatus = BTCLPCore.Status.Open;
        emit BTCLPCore.LotteryOpened(round);
    }

    function calculateWinner(uint256 roundNr)
        public
        view
        returns (address luckyWinner, uint64 sourceChainSelector, uint256 luckyPrize)
    {
        (uint256[] memory rewards) = calculateRewards(rounds[roundNr].status.totalTickets, 0);
        uint256 luckyTicket = (rounds[roundNr].status.randomness % rounds[roundNr].status.totalBets) + 1;
        (address purchaser, uint64 chainSelector,) = unpackPackedValue(roundNr, luckyTicket);
        luckyWinner = purchaser;
        sourceChainSelector = chainSelector;
        luckyPrize = rewards[0];
    }

    /**
     * @dev Calculated Rewards Based on Amount
     * @param totalAmount the address of the purchaser
     * @param decimals the address of the purchaser
     * @return rewards
     */
    function calculateRewards(uint256 totalAmount, uint256 decimals) public pure returns (uint256[] memory rewards) {
        return BTCLPCore.calculateRewards(totalWinners, totalAmount, decimals);
    }

    function transferTokensCCIP(
        uint64 _destinationChainSelector,
        address _receiver,
        address _token,
        uint256 _amount
    ) 
        internal
        onlyWhitelistedChain(_destinationChainSelector)
        returns (bytes32 messageId) 
    {
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: _token,
            amount: _amount
        });
        tokenAmounts[0] = tokenAmount;
        
        // Build the CCIP Message
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver),
            data: "",
            tokenAmounts: tokenAmounts,
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 0, strict: false})
            ),
            feeToken: address(linkToken)
        });
        
        // CCIP Fees Management
        uint256 fees = router.getFee(_destinationChainSelector, message);

        if (fees > linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);

        linkToken.approve(address(router), fees);
        
        // Approve Router to spend CCIP-BnM tokens we send
        IERC20(_token).approve(address(router), _amount);
        
        // Send CCIP Message
        messageId = router.ccipSend(_destinationChainSelector, message); 
        
        emit TokensTransferred(
            messageId,
            _destinationChainSelector,
            _receiver,
            _token,
            _amount,
            address(linkToken),
            fees
        );   
    }

    /**
     * @dev Allows the treasury to claim locked tokens in one round.
     * @param roundNr The round number to claim the prize from.
     */
    function claimTreasury(uint256 roundNr, address treasuryAddress) external onlyOwner nonReentrant {
        if (roundNr >= round) revert BTCLPCore.ROUND_NOT_FINISHED();

        // Check if the round has finished
        if (rounds[roundNr].status.claimedTreasury == true) revert BTCLPCore.PRIZE_ALREADY_CLAIMED();

        // Single Round Fees
        uint256 roundFees = rounds[roundNr].status.totalBets * ticketFee;

        // Mark the prize as claimed
        rounds[roundNr].status.claimedTreasury = true;

        // Send accumulated fees to DAO Multisig
        BTCLPCore.distributionHelper(address(whitelistedToken), msg.sender, roundFees);

        // Emit the TreasuryClaimed event
        emit BTCLPCore.TreasuryClaimedSingle(treasuryAddress, roundFees);
    }

    /**
     * @dev Treasury can provide multiple rounds to get multiple rewards from multiple rounds at once.
     * @param roundNumbers Desired round numbers
     */
    function claimTreasury(uint256[] memory roundNumbers) external onlyOwner nonReentrant {
        uint256 totalAmount;
        for (uint256 i = 0; i < roundNumbers.length; ) {
            if (roundNumbers[i] >= round) revert BTCLPCore.ROUND_NOT_FINISHED();
            if (rounds[roundNumbers[i]].status.claimedTreasury == true) revert BTCLPCore.PRIZE_ALREADY_CLAIMED();

            totalAmount += rounds[roundNumbers[i]].status.totalBets * ticketFee;

            rounds[roundNumbers[i]].status.claimedTreasury = true;

            unchecked {
                ++i;
            }
        }

        // Send accumulated fees to DAO Multisig
        BTCLPCore.distributionHelper(address(whitelistedToken), msg.sender, totalAmount);

        emit BTCLPCore.TreasuryClaimedMulti(msg.sender, roundNumbers);
    }

    /**
     * @dev Returns the status for a player in a specific round
     * @param roundNr desired round number.
     * @param winnerAddress player address.
     * @return claimStatus the prizes of the round
     */
    function getSingleWinnerClaimedPrizesInRound(uint256 roundNr, address winnerAddress)
        external
        view
        returns (bool claimStatus)
    {
        claimStatus = rounds[roundNr].winnerClaimed[winnerAddress] == true;
    }

    /**
     * @dev Returns the status of multiple users in a specific round
     * @param roundNr desired round number.
     * @param winnerAddress player address.
     * @return claimStatus the prizes of the round
     */
    function getMultipleWinnersClaimedPrizesInRound(uint256 roundNr, address[] memory winnerAddress)
        external
        view
        returns (bool[] memory claimStatus)
    {
        for (uint256 i = 0; i < winnerAddress.length; ) {
            claimStatus[i] = rounds[roundNr].winnerClaimed[winnerAddress[i]] == true;
            unchecked {
                ++i;
            }
        }
        return claimStatus;
    }

    /**
     * @dev Returns the status of a specific round
     * @param _round Desired round number.
     * @return status The status of the round
     */
    function getRoundStatus(uint256 _round) external view returns (BTCLPCore.RoundStatus memory status) {
        return rounds[_round].status;
    }

    // 1 x uint256 to store 3 things
    // first 160 bits = player address
    // next 64 bits = CCIP chain selector
    // next 32 bits = tickets bought

    function setPackedValue(uint256 _round, uint256 _key, address _purchaser, uint64 _chainSelector, uint32 _lastIndex) private {
        uint packedValue = (uint160(_purchaser) & BTCLPCore.BITMASK_PURCHASER)
        | (uint256(uint64(_chainSelector)) << BTCLPCore.BITPOS_CHAIN_SELECTOR)
        | (uint256(uint32(_lastIndex)) << BTCLPCore.BITPOS_LAST_INDEX);
        
        rounds[_round].betID[_key] = packedValue;
    }

    function unpackPackedValue(uint256 _round, uint256 _key) public view returns (address purchaser, uint64 chainSelector, uint32 lastIndex) {
        uint packedValue = rounds[_round].betID[_key];
        purchaser = address(uint160(packedValue & BTCLPCore.BITMASK_PURCHASER));
        chainSelector = uint64((packedValue & BTCLPCore.BITMASK_CHAIN_SELECTOR) >> BTCLPCore.BITPOS_CHAIN_SELECTOR);
        lastIndex = uint32((packedValue & BTCLPCore.BITMASK_LAST_INDEX) >> BTCLPCore.BITPOS_LAST_INDEX);
    }

    /**
     * @dev Returns the address of the purchaser for a specific round and key
     * @param _round the round number
     * @param _key the key
     * @return address of the purchaser
     */
    function getPurchaserAddress(uint256 _round, uint256 _key) public view returns (address) {
        return address(uint160(rounds[_round].betID[_key] & BTCLPCore.BITMASK_PURCHASER));
    }

    function getPurchaserChainSelector(uint256 _round, uint256 _key) public view returns (address) {
        return address(uint160(rounds[_round].betID[_key] & BTCLPCore.BITMASK_CHAIN_SELECTOR));
    }

    function getLastBetID(uint256 _round, uint256 _key) public view returns (uint32) {
        return uint32(rounds[_round].betID[_key] & BTCLPCore.BITMASK_LAST_INDEX);
    }

}
