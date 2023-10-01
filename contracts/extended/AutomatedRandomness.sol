// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import {LotteryManager} from "./LotteryManager.sol";

error BLOCK_LIMIT_TO_LOW();
error LINK_WITHDRAWAL_FAILED();

abstract contract AutomatedRandomness is VRFConsumerBaseV2, LotteryManager {
    VRFCoordinatorV2Interface public immutable COORDINATOR;
    LinkTokenInterface public immutable LINKToken;

    uint64 public subscriptionId;
    uint32 public callbackGasLimit; // Gas used for Chainlink Keepers Network calling Chainlink VRF V2 Randomness Function
    uint16 public requestConfirmations; // Min blocks after winner is announced on-chain
    bytes32 public keyHash;

    constructor(address _coordinator, address _linkToken, uint64 _subscriptionId) VRFConsumerBaseV2(_coordinator) LotteryManager() {
        // Vrf Coordonator
        COORDINATOR = VRFCoordinatorV2Interface(0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed);
        // Link Token
        LINKToken = LinkTokenInterface(_linkToken);
        // VRF Subscription ID
        subscriptionId = _subscriptionId;
        // Chainlink VRF and Keepers Max Callback Gas limit
        callbackGasLimit = 2500000;
        // number of confirmations required for VRF requests
        requestConfirmations = 3;
        //  Keccak256 hash of the VRF private key for 200 Gwei Gas Lane
        keyHash = 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;
    }

    function requestRandomness(uint32 _randomNumbers) internal returns (uint256) {
        uint256 requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit, // callback gas limit
            _randomNumbers // randomness big hex numbers
        );
        return requestId;
    }

    /**
     * @dev Set Chainlink VRF Gas Lane
     */
    function setGasLimit(bytes32 _keyHash) external onlyManager {
        keyHash = _keyHash;
    }

    /**
     * @dev Set Chainlink VRF Gas Limits
     */
    function setGasLimit(uint32 _amount) external onlyManager {
        callbackGasLimit = _amount;
    }

    /**
     * @dev Set Chainlink VRF Gas Limits
     */
    function setMinBlockLimit(uint16 _blocks) external onlyManager {
        if (_blocks < 3) revert BLOCK_LIMIT_TO_LOW();
        requestConfirmations = _blocks;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink(address receiverAddress) external onlyManager {
        bool success = LINKToken.transfer(receiverAddress, LINKToken.balanceOf(address(this)));
        if (!success) revert LINK_WITHDRAWAL_FAILED();
    }

    // Function to reject Ether deposits, msg.data must be empty
    // receive() external payable {}

    // Fallback function is called when msg.data is not empty
    // fallback() external payable {}
}
