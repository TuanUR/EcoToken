pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EcoToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("EcoToken", "ETN") {
        _setupDecimals(0);
        _mint(msg.sender, initialSupply);
    }
}