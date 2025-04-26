// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Pausable, Ownable, ERC20Permit {
    uint256 public constant TOKEN_PRICE = 0.001 ether;
    uint256 public constant DECIMALS = 10**18;
    address payable public moneyGetter;

    constructor(address initialOwner, uint256 initialSupply)
    ERC20("MyToken", "MTK")
    Ownable(initialOwner)
    ERC20Permit("MyToken")
    {
        moneyGetter = payable(initialOwner);
        if (initialSupply > 0) {
            _mint(initialOwner, initialSupply * DECIMALS);
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * DECIMALS);
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Must send ETH to buy tokens");
        uint256 tokensToMint = (msg.value * DECIMALS) / TOKEN_PRICE;
        moneyGetter.transfer(msg.value);
        _mint(msg.sender, tokensToMint);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender) / DECIMALS;
    }

    function transferTo(address recipient, uint256 amount) public returns (bool) {
        return transfer(recipient, amount * DECIMALS);
    }

    function _update(address from, address to, uint256 value)
    internal
    override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}