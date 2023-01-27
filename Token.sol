//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 *
 *               ▟██████████   █████    ▟███████████   █████████████
 *             ▟████████████   █████  ▟█████████████   █████████████   ███████████▛
 *            ▐█████████████   █████▟███████▛  █████   █████████████   ██████████▛
 *             ▜██▛    █████   ███████████▛    █████      ▟██████▛   █████████▛
 *               ▀     █████   █████████▛       █████     ▟██████▛
 *                     █████   ███████▛      ▟█████▛   ▟██████▛
 *    ▟█████████████   ██████              ▟█████▛   ▟██████▛   ▟███████████████▙
 *   ▟██████████████   ▜██████▙          ▟█████▛   ▟██████▛   ▟██████████████████▙
 *  ▟███████████████     ▜██████▙      ▟█████▛   ▟██████▛   ▟█████████████████████▙
 *                         ▜██████▙            ▟██████▛          ┌────────┐
 *                           ▜██████▙        ▟██████▛            │  LABS  │
 *                                                                 └────────┘
 */

contract Token {
    uint256 public savedBalance;

    uint256 public pricePerToken;
    mapping(address => uint256) public balances;
    uint256 totalSupply;

    constructor(uint256 pricePerToken_) {
        pricePerToken = pricePerToken_;
    }

    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * pricePerToken, "Incorrect value");
        savedBalance += msg.value;
        totalSupply += amount;
        balances[msg.sender] += amount;
    }

    function sellTokens(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");
        savedBalance -= amount * pricePerToken;
        totalSupply -= amount;
        balances[msg.sender] -= amount;
        (bool success, ) = address(msg.sender).call{value: amount * pricePerToken}("");
        require(success == true, "Transaction failed");
    }

    function transferTokens(address wallet, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");
        balances[msg.sender] -= amount;
        balances[wallet] += amount;
    }
}
