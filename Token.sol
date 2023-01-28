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
    uint256 public totalSupply;

    constructor(uint256 pricePerToken_) {
        pricePerToken = pricePerToken_;
    }

    /**
     * Opens an account if no balance and purchase some tokens.
     * @param amount of tokens to buy
     */
    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * pricePerToken, "Incorrect value");
        savedBalance += msg.value;
        totalSupply += amount;
        balances[msg.sender] += amount;
    }

    /**
     * Sells tokens for the fixed price
     * @param amount of tokens to sell
     */
    function sellTokens(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");
        savedBalance -= amount * pricePerToken;
        totalSupply -= amount;
        balances[msg.sender] -= amount;
        (bool success, ) = address(msg.sender).call{value: amount * pricePerToken}("");
        require(success == true, "Transaction failed");
    }

    /**
     * Transfers tokens to another account
     * @param wallet to transfer
     * @param amount of tokens to transfer
     */
    function transferTokens(address wallet, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");
        balances[msg.sender] -= amount;
        balances[wallet] += amount;
    }
}
