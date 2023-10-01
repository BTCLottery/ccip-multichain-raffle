// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {AutomationCompatible} from "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";
import {AutomatedRandomness} from "./extended/AutomatedRandomness.sol";
import {BTCLCoreFixed} from "./libraries/BTCLCoreFixed.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {LotterySender} from "./LotterySender.sol";
import {LotteryReceiver} from "./LotteryReceiver.sol";

/**
 * @title v1.0 Beta Version
 * @notice Website: https://btclottery.io
 * @dev This contract utilises Chainlink Verifiable Random Function (VRF) + Automation Keeper Subscription for trustlesness
 * @dev This contract is an immutable EVM Raffle Game with a fixed and unchangeable configuration that was set on deployment
 */
contract BTCLFixedLottery is
    AutomationCompatible,
    AutomatedRandomness,
    ReentrancyGuard,
    LotteryReceiver,
    LotterySender
{
    /* ============ Global Variables ============ */
    using SafeERC20 for IERC20;

    // Mapping the details of each round
    mapping(uint256 => BTCLCoreFixed.Round) public rounds;

    // Round configuration
    uint256 public round;
    uint256 public immutable ticketPrice;
    uint256 public immutable ticketFee;
    uint256 public immutable maxPlayers;
    uint256 public immutable totalWinners;

    /**
     * @dev Constructor for the BTCL Daily Lottery contract
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
        uint256 _totalWinners,
        uint64 _subscriptionId
    )
        AutomatedRandomness(_coordinator, _linkToken, _subscriptionId)
        LotteryReceiver(_ccipReceiveRouter)
        LotterySender(_ccipSendRouter, _linkToken)
    {
        // Initialize the round number to 1
        round = 1;
        // Set the status of the first round to open
        rounds[round].status.roundStatus = BTCLCoreFixed.Status.Open;
        // Set max players
        maxPlayers = _maxPlayers;
        // Set ticket price
        ticketPrice = _ticketPrice;
        // Set ticket fee
        ticketFee = _ticketFee;
        // Set ticket fee
        totalWinners = _totalWinners;
        whitelistedToken = IERC20(_whitelistedToken);
        // Emit first round event
        emit BTCLCoreFixed.LotteryOpened(round);
    }

    /* ============ External Functions ============ */
    /**
     * @notice If high demand you will buy a ticket in a future round
     * @dev Function that allows players to purchase 1 ticket per address
     */
    function buyTicket(uint256 _amount) public returns (uint256 roundNr) {
        return purchaseTickets(selectRound(), _amount);
    }

    /**
     * @dev Find available ticket in future rounds
     */
    function selectRound() private view returns (uint256) {
        uint256 currentRound = round;
        while (rounds[currentRound].status.totalBets >= maxPlayers || rounds[currentRound].contributed[msg.sender] > 0)
        {
            currentRound++;
        }
        return currentRound;
    }

    function purchaseTickets(uint256 roundNr, uint256 _amount) private returns (uint256 roundNumber) {
        // Check if the lottery is paused and that there is a new round, if yes, revert the transaction
        if (paused == true && rounds[roundNr].status.totalBets == 0) revert BTCLCoreFixed.LOTTERY_PAUSED();

        // Check if the round is open, if not, revert the transaction
        if (rounds[roundNr].status.roundStatus != BTCLCoreFixed.Status.Open) revert BTCLCoreFixed.TRANSFER_FAILED();

        // Check if the MATIC provided is equal to ticket price plus fee exactly
        if (_amount != ticketPrice + ticketFee) revert BTCLCoreFixed.TRANSFER_FAILED();
        // add erc20 bnm
        // replace msg.value with amount

        // Check if already bought a ticket in the current round
        if (rounds[roundNr].contributed[msg.sender] > 0) revert BTCLCoreFixed.TRANSFER_FAILED();

        whitelistedToken.transferFrom(msg.sender, address(this), _amount);

        // Set Contribution amount
        rounds[roundNr].contributed[msg.sender] = _amount;

        // get next bet id and current last ticket index
        uint256 nextBet = rounds[roundNr].status.totalBets + 1;
        uint256 lastIndex = getLastIndex(roundNr, rounds[roundNr].status.totalBets);

        // sets the purchaser address and ticket amount for the next bet
        setPurchaser(roundNr, nextBet, msg.sender);
        setLastIndex(roundNr, nextBet, lastIndex + 1);

        uint256 totalTickets = rounds[roundNr].status.totalTickets + (_amount - ticketFee);

        // increment the total bets and total tickets of the round
        rounds[roundNr].status.totalBets = nextBet;
        rounds[roundNr].status.totalTickets = totalTickets;

        // emit event to log the purchase
        emit BTCLCoreFixed.TicketsPurchased(roundNr, msg.sender, _amount, nextBet, totalTickets);
        return roundNr;
    }

    /**
     * @dev param calldata the calldata which is used to determine the type of upkeep.
     * @return upkeepNeeded true if and only if at least max players have joined the round.
     * @return performData the data that needs to be performed based on calldata type.
     */
    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = BTCLCoreFixed.checkUpkeepVRF(
            rounds[round].status.roundStatus, rounds[round].status.requestId, rounds[round].status.totalBets, maxPlayers
        );
        performData = abi.encode(round);
    }

    /**
     * @notice Requests randomness from the VRF coordinator
     */
    function performUpkeep(bytes calldata performData) external override {
        // Check if the function is being called at the correct time
        bool reqRandomness = BTCLCoreFixed.checkUpkeepVRF(
            rounds[round].status.roundStatus, rounds[round].status.requestId, rounds[round].status.totalBets, maxPlayers
        );

        // Decode the performData to retrieve the round number, winningBetID, and userAddress
        (uint256 _round) = abi.decode(performData, (uint256));

        // Check if the function is being called with the correct parameters
        if (round != _round) revert BTCLCoreFixed.UPKEEP_FAILED();
        if (rounds[round].status.roundStatus != BTCLCoreFixed.Status.Open) revert BTCLCoreFixed.UPKEEP_FAILED();

        // Check if we need to request randomness
        if (reqRandomness) {
            rounds[round].status.roundStatus = BTCLCoreFixed.Status.Drawing;
            rounds[round].status.requestId = requestRandomness(uint32(totalWinners));
            emit BTCLCoreFixed.LotteryClosed(round, rounds[round].status.totalTickets, rounds[round].status.totalBets);
        }
    }

    /**
     * @notice Requests randomness from the VRF coordinator and save the random numbers in the draw
     * @param requestId the VRF V2 request ID, provided at request time.
     * @param randomness the randomness provided by Chainlink VRF.
     */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomness) internal override {
        // Check if the request ID matches with the request ID of the current round
        if (rounds[round].status.requestId != requestId) revert BTCLCoreFixed.INVALID_VRF_REQUEST();

        // Change the status of the round from Drawing and save winning VRF randomness
        rounds[round].status.roundStatus = BTCLCoreFixed.Status.Completed;
        rounds[round].status.requestId = requestId;
        rounds[round].status.randomness = randomness;

        // Set next round
        round = round + 1;
        rounds[round].status.roundStatus = BTCLCoreFixed.Status.Open;
        emit BTCLCoreFixed.LotteryOpened(round);
    }

    function calculateWinners(uint256 roundNr)
        public
        view
        returns (address[] memory luckyWinners, uint256[] memory luckyTickets, uint256[] memory luckyPrizes)
    {
        (uint256[] memory rewards) = calculateRewards(rounds[roundNr].status.totalTickets, 0);
        luckyWinners = new address[](totalWinners);
        luckyTickets = new uint[](totalWinners);
        luckyPrizes = new uint[](totalWinners);
        for (uint256 i = 0; i < totalWinners; i++) {
            uint256 luckyTicket = (rounds[roundNr].status.randomness[i] % rounds[roundNr].status.totalBets) + 1;
            luckyWinners[i] = getPurchaser(roundNr, luckyTicket);
            luckyTickets[i] = luckyTicket;
            luckyPrizes[i] = rewards[i];
        }
    }

    /**
     * @dev Winner can claim prizes from a specific round.
     * @param roundNr Desired round number.
     */
    function claim(uint256 roundNr) external nonReentrant {
        uint256 totalAmount;

        if (roundNr >= round) revert BTCLCoreFixed.ROUND_NOT_FINISHED();

        if (rounds[roundNr].winnerClaimed[msg.sender] == true) revert BTCLCoreFixed.PRIZE_ALREADY_CLAIMED();

        (address[] memory luckyWinners,, uint256[] memory luckyPrizes) = calculateWinners(roundNr);

        for (uint256 i = 0; i < rounds[roundNr].status.randomness.length; i++) {
            if (luckyWinners[i] == msg.sender) {
                totalAmount += luckyPrizes[i];
            }
        }

        if (totalAmount == 0) revert BTCLCoreFixed.UNAUTHORIZED_WINNER();

        BTCLCoreFixed.distributionHelper(msg.sender, totalAmount);

        rounds[roundNr].winnerClaimed[msg.sender] == true;

        emit BTCLCoreFixed.WinnerClaimedPrizeSingle(msg.sender, totalAmount);
    }

    /**
     * @dev Winners can provide multiple rounds to get multiple rewards from multiple rounds at once.
     * @param roundNumbers Desired round numbers
     */
    function multiClaim(uint256[] memory roundNumbers) external nonReentrant {
        uint256 totalAmount;

        for (uint256 i = 0; i < roundNumbers.length; i++) {
            if (roundNumbers[i] >= round) revert BTCLCoreFixed.ROUND_NOT_FINISHED();
            if (rounds[roundNumbers[i]].winnerClaimed[msg.sender] == true) revert BTCLCoreFixed.PRIZE_ALREADY_CLAIMED();

            (address[] memory luckyWinners,, uint256[] memory luckyPrizes) = calculateWinners(roundNumbers[i]);

            for (uint256 j = 0; j < luckyWinners.length; j++) {
                if (luckyWinners[j] == msg.sender) {
                    totalAmount += luckyPrizes[j];
                }
            }

            rounds[roundNumbers[i]].winnerClaimed[msg.sender] = true;
        }

        if (totalAmount == 0) revert BTCLCoreFixed.UNAUTHORIZED_WINNER();
        BTCLCoreFixed.distributionHelper(msg.sender, totalAmount);

        emit BTCLCoreFixed.WinnerClaimedPrizeMulti(msg.sender, roundNumbers);
    }

    /**
     * @dev Allows the treasury to claim locked tokens in one round.
     * @param roundNr The round number to claim the prize from.
     */
    function claimTreasury(uint256 roundNr, address treasuryAddress) external onlyOwner nonReentrant {
        if (roundNr >= round) revert BTCLCoreFixed.ROUND_NOT_FINISHED();

        // Check if the round has finished
        if (rounds[roundNr].status.claimedTreasury == true) revert BTCLCoreFixed.PRIZE_ALREADY_CLAIMED();

        // Single Round Fees
        uint256 roundFees = rounds[roundNr].status.totalBets * ticketFee;

        // Mark the prize as claimed
        rounds[roundNr].status.claimedTreasury = true;

        // Send accumulated fees to DAO Multisig
        BTCLCoreFixed.distributionHelper(msg.sender, roundFees);

        // Emit the TreasuryClaimed event
        emit BTCLCoreFixed.TreasuryClaimedSingle(treasuryAddress, roundFees);
    }

    /**
     * @dev Treasury can provide multiple rounds to get multiple rewards from multiple rounds at once.
     * @param roundNumbers Desired round numbers
     */
    function claimTreasury(uint256[] memory roundNumbers) external onlyOwner nonReentrant {
        uint256 totalAmount;
        for (uint256 i = 0; i < roundNumbers.length; i++) {
            if (roundNumbers[i] >= round) revert BTCLCoreFixed.ROUND_NOT_FINISHED();
            if (rounds[roundNumbers[i]].status.claimedTreasury == true) revert BTCLCoreFixed.PRIZE_ALREADY_CLAIMED();

            totalAmount += rounds[roundNumbers[i]].status.totalBets * ticketFee;

            rounds[roundNumbers[i]].status.claimedTreasury = true;
        }

        // Send accumulated fees to DAO Multisig
        BTCLCoreFixed.distributionHelper(msg.sender, totalAmount);

        emit BTCLCoreFixed.TreasuryClaimedMulti(msg.sender, roundNumbers);
    }

    /**
     * @dev Returns a single status for a single user in a specific round
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
        for (uint256 i = 0; i < winnerAddress.length; i++) {
            claimStatus[i] = rounds[roundNr].winnerClaimed[winnerAddress[i]] == true;
        }
        return claimStatus;
    }

    /**
     * @dev Returns the status of a specific round
     * @param _round Desired round number.
     * @return status The status of the round
     */
    function getRoundStatus(uint256 _round) external view returns (BTCLCoreFixed.RoundStatus memory status) {
        return rounds[_round].status;
    }

    /**
     * @dev Calculated Rewards Based on Amount
     * @param totalAmount the address of the purchaser
     * @param decimals the address of the purchaser
     * @return rewards
     */
    function calculateRewards(uint256 totalAmount, uint256 decimals) public view returns (uint256[] memory rewards) {
        return BTCLCoreFixed.calculateRewards(totalWinners, totalAmount, decimals);
    }

    /**
     * @dev Sets the purchaser of the ticket
     * @param _key the key of the ticket
     * @param _purchaser the address of the purchaser
     */
    function setPurchaser(uint256 _round, uint256 _key, address _purchaser) private {
        rounds[_round].betID[_key] = uint256(uint160(_purchaser)) & BTCLCoreFixed.BITMASK_PURCHASER;
    }

    /**
     * @dev Returns the address of the purchaser for a specific round and key
     * @param _round the round number
     * @param _key the key
     * @return address of the purchaser
     */
    function getPurchaser(uint256 _round, uint256 _key) public view returns (address) {
        return address(uint160(rounds[_round].betID[_key] & BTCLCoreFixed.BITMASK_PURCHASER));
    }

    /**
     * @dev Sets the last index for a specific round and key
     * @param _key the key
     * @param lastIndex the last index
     */
    function setLastIndex(uint256 _round, uint256 _key, uint256 lastIndex) private {
        rounds[_round].betID[_key] = (lastIndex << BTCLCoreFixed.BITPOS_LAST_INDEX)
            | (rounds[_round].betID[_key] & ~BTCLCoreFixed.BITMASK_LAST_INDEX);
    }

    /**
     * @dev Returns the last index for a specific round and key
     * @param _round the round number
     * @param _key the key
     * @return last index
     */
    function getLastIndex(uint256 _round, uint256 _key) public view returns (uint256) {
        return (rounds[_round].betID[_key] & BTCLCoreFixed.BITMASK_LAST_INDEX) >> BTCLCoreFixed.BITPOS_LAST_INDEX;
    }
}
