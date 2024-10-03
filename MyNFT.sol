// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 private _tokenIdCounter;

    // Konstruktor
    constructor() ERC721("MyNFT", "MNFT") {
        _tokenIdCounter = 0; // Initialisiere den Token-Zähler
    }

    // Minting-Funktion
    function mint(address to) public {
        // Überprüfen, ob der Sender die Berechtigung hat (optional)
        require(msg.sender != address(0), "Invalid address");
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }
}

