// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

import {LotteryManager} from "./LotteryManager.sol";

abstract contract WhitelistManager is LotteryManager {
    mapping(address => bool) public isWhitelisted;

    function setWhitelist(address _playerAddress, bool _isWhitelisted) external onlyManager {
        isWhitelisted[_playerAddress] = _isWhitelisted;
    }
}
