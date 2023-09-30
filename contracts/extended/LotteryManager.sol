// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

contract LotteryManager {
    error NOT_MANAGER();
    error ADDRESS_ZERO();

    bool public paused;
    address public manager;

    /**
     * @notice Lottery Owner & Pausable Helper Functions
     */
    constructor() {
        manager = msg.sender;
        paused = false;
    }

    /**
     * @dev Owner Modifier
     */
    modifier onlyManager() {
        if (manager != msg.sender) revert NOT_MANAGER();
        _;
    }

    /**
     * @dev Transfer Lottery Owner
     */
    function transferManager(address newManager) external onlyManager {
        if (newManager == address(0)) revert ADDRESS_ZERO();
        manager = newManager;
    }

    /**
     * @dev Pause Lottery
     */
    function pause() external onlyManager {
        paused = true;
    }

    /**
     * @dev Unpause Lottery
     */
    function unpause() external onlyManager {
        paused = false;
    }
}
