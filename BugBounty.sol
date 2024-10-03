// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BugBounty is Ownable {
    IERC20 public sectToken;

    mapping(address => uint256) public rewards;
    uint256 public totalBountyPool;

    event BountyAllocated(address indexed hunter, uint256 amount);
    event BountyClaimed(address indexed hunter, uint256 amount);

    // Konstruktor, der die Adresse des SECT Tokens und den initialen Besitzer erwartet
    constructor(address _sectTokenAddress) Ownable(msg.sender) {
        sectToken = IERC20(_sectTokenAddress);
        totalBountyPool = 50000 * 10 ** 18; // Initial pool of 50,000 SECT
    }

    // Funktion, um Belohnungen zuzuweisen
    function allocateBounty(address hunter, uint256 amount) external onlyOwner {
        require(amount <= totalBountyPool, "Not enough tokens in the bounty pool");
        rewards[hunter] += amount;
        totalBountyPool -= amount;
        emit BountyAllocated(hunter, amount);
    }

    // Sicherheitsforscher können ihre Belohnungen abheben
    function claimBounty() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No bounty allocated");

        rewards[msg.sender] = 0;
        sectToken.transfer(msg.sender, reward);

        emit BountyClaimed(msg.sender, reward);
    }

    // Funktion, um den Bug Bounty Pool aufzufüllen
    function fundBountyPool(uint256 amount) external onlyOwner {
        sectToken.transferFrom(msg.sender, address(this), amount);
        totalBountyPool += amount;
    }

    // Überprüfen des Bounty Pools
    function getBountyPoolBalance() external view returns (uint256) {
        return totalBountyPool;
    }
}
