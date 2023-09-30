// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

contract LotteryManager {
    error NOT_OWNER();
    error ADDRESS_ZERO();

    bool public paused;
    address public owner;
    
    /**
     * @notice Lottery Owner & Pausable Helper Functions
     */
    constructor(bool _paused) {
        owner = msg.sender;
        paused = _paused;
    }

    /**
     * @dev Owner Modifier
     */
    modifier onlyOwner() {
        if (owner != msg.sender) revert NOT_OWNER();
        _;
    }

    /**
     * @dev Transfer Lottery Owner
     */
    function transferOwnership(address newOwner) external onlyOwner {
        if(newOwner == address(0)) revert ADDRESS_ZERO();
        owner = newOwner;
    }

    /**
     * @dev Pause Lottery
     */
    function pause() external onlyOwner {
        paused = true;
    }

    /**
     * @dev Unpause Lottery
     */
    function unpause() external onlyOwner {
        paused = false;
    }
}