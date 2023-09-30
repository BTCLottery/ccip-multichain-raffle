// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";

contract LotterySender is OwnerIsCreator {
    address link;
    address router;

    mapping(uint64 => bool) public whitelistedChains;

    error DestinationChainNotWhitelisted(uint64 destinationChainSelector);

    modifier onlyWhitelistedChain(uint64 _destinationChainSelector) {
        if (!whitelistedChains[_destinationChainSelector]) {
            revert DestinationChainNotWhitelisted(_destinationChainSelector);
        }
        _;
    }

    constructor(address _link, address _router) {
        link = _link;
        router = _router;
        LinkTokenInterface(link).approve(router, type(uint256).max);
    }

    function send(address receiver, string memory someText, uint64 destinationChainSelector) internal {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encode(someText),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: link
        });

        IRouterClient(router).ccipSend(destinationChainSelector, message);
    }

    function whitelistChain(uint64 _destinationChainSelector) external onlyOwner {
        whitelistedChains[_destinationChainSelector] = true;
    }

    function denylistChain(uint64 _destinationChainSelector) external onlyOwner {
        whitelistedChains[_destinationChainSelector] = false;
    }
}
