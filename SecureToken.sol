// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// SecureToken Contract 
contract SecureToken is ERC20, ERC20Permit, Ownable {
    // Initial Supply von 1.000.000 SECT
    uint256 private constant _initialSupply = 1000000 * 10 ** 18; // 1.000.000 SECT mit 18 Dezimalstellen

    // Konstruktor
    constructor() 
        ERC20("SecureToken", "SECT") 
        ERC20Permit("SecureToken") 
        Ownable(msg.sender) // Hier Ownable mit msg.sender aufrufen
    {
        // Mint Initial Supply an den Ersteller des Contracts
        _mint(msg.sender, _initialSupply);
    }

    // Burning-Funktion
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Funktion für den Token Buyback und Burn
    function buybackAndBurn(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= balanceOf(address(this)), "Insufficient contract balance");

        // Token von diesem Contract kaufen und verbrennen
        _burn(address(this), amount);
    }

    // Optional: Funktion zum Empfang von Ether für den Buyback
    receive() external payable {}
}

