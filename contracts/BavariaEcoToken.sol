pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BavariaEcoToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("BavariaEcoToken", "BET") {
        _setupDecimals(0);
        _mint(msg.sender, initialSupply);
    }
}