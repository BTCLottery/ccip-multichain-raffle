// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

/**
 * @title Bitcoin Lottery Protocol Core Library - v0.1 Beta
 * @dev Multichain Raffles Functionality
 */ 
library BTCLPCore {
    error UPKEEP_FAILED();
    error LOTTERY_PAUSED();
    error TRANSFER_FAILED();
    error ROUND_NOT_FINISHED();
    error INVALID_VRF_REQUEST();
    error UNAUTHORIZED_WINNER();
    error PRIZE_ALREADY_CLAIMED();
    error CCIP_WRONG_CHAIN_SELECTOR();

    enum Status {
        Open,
        Drawing,
        Completed
    }

    struct RoundStatus {
        Status roundStatus;    // Round active lottery status
        uint requestId;        // Round Chainlink VRF Request ID
        uint totalTickets;     // Round Tickets Purchased
        uint totalBets;        // Round Bet ID Number
        uint[] randomness;     // Round Random Numbers
        bool claimedTreasury;  // Round treasury fees claimed
    }

    struct Round {
        RoundStatus status; // Round Info
        mapping(address => bool) winnerClaimed; // Round winner prizes claimed
        mapping(address => uint) contributed; // MATIC Contributed
        mapping(uint => uint) betID; // Compacted address and tickets purchased for every betID
    }

    // Updated Bitmasks
    uint public constant BITMASK_PURCHASER = (1 << 160) - 1;
    uint public constant BITMASK_CHAIN_SELECTOR = ((1 << 64) - 1) << 160;
    uint public constant BITMASK_LAST_INDEX = ((1 << 32) - 1) << 224;

    // Updated Bit positions
    uint public constant BITPOS_CHAIN_SELECTOR = 160;
    uint public constant BITPOS_LAST_INDEX = 224;

    /* ============ Events ============ */
    // Event emitted when a new lottery round is opened
    event LotteryOpened(uint roundNr);
    // Event emitted when a lottery round is closed
    event LotteryClosed(uint roundNr, uint totalTickets, uint totalPlayers);
    // Event emitted when a player purchases lottery tickets
    event TicketsPurchased(uint roundNr, address player, uint amount, uint totalBets, uint totalTickets);
    // Event emitted when Team Multisig claims fees and transfers them to the Gnosis Vault Multisig
    event TreasuryClaimedSingle(address player, uint amount);
    event TreasuryClaimedMulti(address player, uint[] amount);
    // Event emitted when Team Multisig claims fees and transfers them to the Gnosis Vault Multisig
    event WinnerClaimedPrizeSingle(address player, uint rounds);
    event WinnerClaimedPrizeMulti(address player, uint[] rounds);
    // Event emitted when Team Multisig claims fees and transfers them to the Gnosis Vault Multisig
    event TokensLiquified(uint amountToken, uint amountETH, uint liquidity);

    /**
     * @dev Check if the current round meets the requirements for requesting a new VRF seed.
     * @return A boolean indicating if the conditions for requesting a new VRF seed have been met.
     */
    function checkUpkeepVRF(
        Status status,
        uint requestId,
        uint totalBets,
        uint maxPlayers
    ) public pure returns (bool) {
        if (status == Status.Open && requestId == 0 && totalBets == maxPlayers) return true;
        return false;
    }

    /**
     * @dev Rewards Calculator
     * @param totalWinners number of active participants
     * @param totalAmount number of tickets in stablecoins
     * @param decimals number of decimals for token precission
     * @return rewards an array of rewards depending on how many players have joined
     */
    function calculateRewards(
        uint totalWinners,
        uint totalAmount,
        uint decimals
    ) public pure returns (uint[] memory rewards) {
        if (totalWinners < 1 || totalWinners > 10) return (new uint[](0));
        rewards = new uint[](totalWinners);

        if(totalWinners == 1){
            rewards[0] = totalAmount * (10 ** decimals);     // 100%
            return rewards;
        }
        if(totalWinners == 2){
            rewards[0] = (6 * totalAmount) * (10 ** decimals) / 10;     // 60%
            rewards[1] = (4 * totalAmount) * (10 ** decimals) / 10;     // 40%
            return rewards;
        }
        if (totalWinners == 3) {
            rewards[0] = ((45 * totalAmount) * (10 ** decimals)) / 100; // 45%
            rewards[1] = ((35 * totalAmount) * (10 ** decimals)) / 100; // 35%
            rewards[2] = ((20 * totalAmount) * (10 ** decimals)) / 100; // 20%
            return rewards;
        }
        if (totalWinners == 4) {
            rewards[0] = ((45 * totalAmount) * (10 ** decimals)) / 100; // 45%
            rewards[1] = ((3 * totalAmount) * (10 ** decimals)) / 10;   // 30%
            rewards[2] = ((15 * totalAmount) * (10 ** decimals)) / 100; // 15%
            rewards[3] = ((10 * totalAmount) * (10 ** decimals)) / 100;  // 10%
            return rewards;
        }
        // 10 MATIC - 1.1 MATIC - 5 PRIZES
        if (totalWinners == 5) {
            rewards[0] = ((5 * totalAmount) * (10 ** decimals)) / 10;   // 50%
            rewards[1] = ((21 * totalAmount) * (10 ** decimals)) / 100; // 21%
            rewards[2] = ((12 * totalAmount) * (10 ** decimals)) / 100; // 12%
            rewards[3] = ((9 * totalAmount) * (10 ** decimals)) / 100;  // 9%
            rewards[4] = ((8 * totalAmount) * (10 ** decimals)) / 100;  // 8%
            return rewards;
        }
        if (totalWinners == 6) {
            rewards[0] = ((5 * totalAmount) * (10 ** decimals)) / 10; // 50%
            rewards[1] = ((2 * totalAmount) * (10 ** decimals)) / 10; // 20%
            rewards[2] = ((1 * totalAmount) * (10 ** decimals)) / 10; // 10%
            rewards[3] = ((8 * totalAmount) * (10 ** decimals)) / 100; // 8%
            rewards[4] = ((7 * totalAmount) * (10 ** decimals)) / 100; // 7%
            rewards[5] = ((5 * totalAmount) * (10 ** decimals)) / 100; // 5%
            return rewards;
        }
        if (totalWinners == 7) {
            rewards[0] = ((5 * totalAmount) * (10 ** decimals)) / 10; // 50%
            rewards[1] = ((2 * totalAmount) * (10 ** decimals)) / 10; // 20%
            rewards[2] = ((8 * totalAmount) * (10 ** decimals)) / 100; // 8%
            rewards[3] = ((7 * totalAmount) * (10 ** decimals)) / 100; // 7%
            rewards[4] = ((6 * totalAmount) * (10 ** decimals)) / 100; // 6%
            rewards[5] = ((5 * totalAmount) * (10 ** decimals)) / 100; // 5%
            rewards[6] = ((4 * totalAmount) * (10 ** decimals)) / 100; // 4%
            return rewards;
        }
        if (totalWinners == 8) {
            rewards[0] = ((5 * totalAmount) * (10 ** decimals)) / 10; // 50%
            rewards[1] = ((15 * totalAmount) * (10 ** decimals)) / 100; // 15%
            rewards[2] = ((1 * totalAmount) * (10 ** decimals)) / 10; // 10%
            rewards[3] = ((7 * totalAmount) * (10 ** decimals)) / 100; // 7%
            rewards[4] = ((6 * totalAmount) * (10 ** decimals)) / 100; // 6%
            rewards[5] = ((5 * totalAmount) * (10 ** decimals)) / 100; // 5%
            rewards[6] = ((4 * totalAmount) * (10 ** decimals)) / 100; // 4%
            rewards[7] = ((3 * totalAmount) * (10 ** decimals)) / 100; // 3%
            return rewards;
        }
        if (totalWinners == 9) {
            rewards[0] = ((5 * totalAmount) * (10 ** decimals)) / 10; // 50%
            rewards[1] = ((15 * totalAmount) * (10 ** decimals)) / 100; // 15%
            rewards[2] = ((8 * totalAmount) * (10 ** decimals)) / 100; // 8%
            rewards[3] = ((7 * totalAmount) * (10 ** decimals)) / 100; // 7%
            rewards[4] = ((6 * totalAmount) * (10 ** decimals)) / 100; // 6%
            rewards[5] = ((5 * totalAmount) * (10 ** decimals)) / 100; // 5%
            rewards[6] = ((4 * totalAmount) * (10 ** decimals)) / 100; // 4%
            rewards[7] = ((3 * totalAmount) * (10 ** decimals)) / 100; // 3%
            rewards[8] = ((2 * totalAmount) * (10 ** decimals)) / 100; // 2%
            return rewards;
        }
        if (totalWinners == 10) {
            rewards[0] = ((5 * totalAmount) * (10 ** decimals)) / 10; // 50%
            rewards[1] = ((2 * totalAmount) * (10 ** decimals)) / 10; // 18%
            rewards[2] = ((1 * totalAmount) * (10 ** decimals)) / 10; // 10%
            rewards[3] = ((6 * totalAmount) * (10 ** decimals)) / 100; // 6%
            rewards[4] = ((44 * totalAmount) * (10 ** decimals)) / 1000; // 4.4%
            rewards[5] = ((3 * totalAmount) * (10 ** decimals)) / 100; // 3%
            rewards[6] = ((24 * totalAmount) * (10 ** decimals)) / 1000; // 2.4%
            rewards[7] = ((22 * totalAmount) * (10 ** decimals)) / 1000; // 2.2%
            rewards[8] = ((2 * totalAmount) * (10 ** decimals)) / 100; // 2%
            rewards[9] = ((2 * totalAmount) * (10 ** decimals)) / 100; // 2%
            return rewards;
        }
    }

    /**
     * @dev Private function to transfer MATIC from to the specified address
     * @param to The address to transfer the MATIC to
     * @param amount The amount of MATIC to transfer
     */
    function distributionHelper(address to, uint256 amount) public {
        (bool success, ) = to.call{value: amount}("");
        if(!success) revert TRANSFER_FAILED();
    }

    /**
     * @dev Private function to transfer MATIC from to the specified address
     * @param to The address to transfer the MATIC to
     * @param amount The amount of MATIC to transfer
     */
    function ccipDistributionHelper(address to, uint256 amount) public {
        (bool success, ) = to.call{value: amount}("");
        if(!success) revert TRANSFER_FAILED();
    }
}
