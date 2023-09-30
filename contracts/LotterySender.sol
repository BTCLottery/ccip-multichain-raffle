// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract LotterySender is OwnerIsCreator {
    LinkTokenInterface linkToken;
    IRouterClient router;
    IERC20 whitelistedToken;

    mapping(uint64 => bool) public whitelistedChains;

    error DestinationChainNotWhitelisted(uint64 destinationChainSelector);
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees);

    // The chain selector of the destination chain.
    // The address of the receiver on the destination chain.
    // The token address that was transferred.
    // The token amount that was transferred.
    // the token address used to pay CCIP fees.
    // The fees paid for sending the message.
    event TokensTransferred( // The unique ID of the message.
        bytes32 indexed messageId,
        uint64 indexed destinationChainSelector,
        address receiver,
        address token,
        uint256 tokenAmount,
        address feeToken,
        uint256 fees
    );

    modifier onlyWhitelistedChain(uint64 _destinationChainSelector) {
        if (!whitelistedChains[_destinationChainSelector]) {
            revert DestinationChainNotWhitelisted(_destinationChainSelector);
        }
        _;
    }

    constructor(address _router, address _link) {
        router = IRouterClient(_router);
        linkToken = LinkTokenInterface(_link);
    }

    function whitelistChain(uint64 _destinationChainSelector) external onlyOwner {
        whitelistedChains[_destinationChainSelector] = true;
    }

    function denylistChain(uint64 _destinationChainSelector) external onlyOwner {
        whitelistedChains[_destinationChainSelector] = false;
    }

    function transferTokens(uint64 _destinationChainSelector, address _receiver, address _token, uint256 _amount)
        external
        onlyOwner
        onlyWhitelistedChain(_destinationChainSelector)
        returns (bytes32 messageId)
    {
        Client.EVMTokenAmount[] memory tokenAmounts = new Client.EVMTokenAmount[](1);
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({token: _token, amount: _amount});
        tokenAmounts[0] = tokenAmount;

        // Build the CCIP Message
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver),
            data: abi.encodeWithSignature("mint(address)", msg.sender),
            tokenAmounts: tokenAmounts,
            extraArgs: Client._argsToBytes(Client.EVMExtraArgsV1({gasLimit: 200_000, strict: false})),
            feeToken: address(linkToken)
        });

        // CCIP Fees Management
        uint256 fees = router.getFee(_destinationChainSelector, message);

        if (fees > linkToken.balanceOf(address(this))) {
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);
        }

        linkToken.approve(address(router), fees);

        // Approve Router to spend CCIP-BnM tokens we send
        IERC20(_token).approve(address(router), _amount);

        // Send CCIP Message
        messageId = router.ccipSend(_destinationChainSelector, message);

        emit TokensTransferred(
            messageId, _destinationChainSelector, _receiver, _token, _amount, address(linkToken), fees
        );
    }
}
