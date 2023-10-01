// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";

abstract contract LotteryReceiver is CCIPReceiver, OwnerIsCreator {
    mapping(uint64 => bool) public whitelistedSourceChains;
    mapping(address => bool) public whitelistedSenders;

    error SourceChainNotWhitelisted(uint64 sourceChainSelector);
    error SenderNotWhitelisted(address sender);

    modifier onlyWhitelistedSourceChain(uint64 _sourceChainSelector) {
        if (!whitelistedSourceChains[_sourceChainSelector]) {
            revert SourceChainNotWhitelisted(_sourceChainSelector);
        }
        _;
    }

    modifier onlyWhitelistedSenders(address _sender) {
        if (!whitelistedSenders[_sender]) revert SenderNotWhitelisted(_sender);
        _;
    }

    constructor(address router) CCIPReceiver(router) {}

    function whitelistSourceChain(uint64 _sourceChainSelector) external onlyOwner {
        whitelistedSourceChains[_sourceChainSelector] = true;
    }

    function denylistSourceChain(uint64 _sourceChainSelector) external onlyOwner {
        whitelistedSourceChains[_sourceChainSelector] = false;
    }

    function whitelistSender(address _sender) external onlyOwner {
        whitelistedSenders[_sender] = true;
    }

    function denySender(address _sender) external onlyOwner {
        whitelistedSenders[_sender] = false;
    }
}
