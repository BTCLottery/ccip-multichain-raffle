// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mock is ERC20 {

    uint8 private _decimals;
    constructor(string memory _name, string memory _symbol, uint8 __decimals) ERC20(_name,_symbol) { 
        _decimals = __decimals; 
        _mint(msg.sender, 1000000 * 10 ** _decimals);
    }
	
	function mintTokens(uint _numberOfTokens) external {
		_mint(msg.sender, _numberOfTokens * (10 ** _decimals));
    }
	
	function decimals() public view virtual override returns (uint8) {
	  return _decimals;
	}
	
}