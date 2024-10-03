// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Marketplace {
    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Listing)) public listings; // NFT-Adresse => (Token-ID => Listing)

    // Listing einer NFT für den Verkauf
    function listNFT(address nftAddress, uint256 tokenId, uint256 price) public {
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "You do not own this NFT");
        require(price > 0, "Price must be greater than zero");

        listings[nftAddress][tokenId] = Listing(msg.sender, price);
    }

    // Kauf einer gelisteten NFT
    function buyNFT(address nftAddress, uint256 tokenId) public payable {
        Listing memory listing = listings[nftAddress][tokenId];
        require(msg.value == listing.price, "Incorrect price");
        require(listing.seller != address(0), "NFT not listed for sale");

        // Transfer der NFT
        IERC721(nftAddress).transferFrom(listing.seller, msg.sender, tokenId);
        
        // Bezahlung an den Verkäufer
        payable(listing.seller).transfer(msg.value);
        
        // Listing entfernen
        delete listings[nftAddress][tokenId];
    }
}
