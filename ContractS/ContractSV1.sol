// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract ContractSV1 is ERC721 {
    // custom error
    error InvalidQuantity();

    // the next token ID to mint
    uint256 private _nextTokenId;

    constructor() ERC721("Test Token", "TTK") {
        _nextTokenId = 1;
    }

    // singular function to mint 1 or multiple NFTs
    function batchMint(address to, uint256 quantity) public {
        if (quantity == 0) revert InvalidQuantity();

        for (uint256 i = 0; i < quantity; i++) {
            _safeMint(to, _nextTokenId);

            unchecked {
                _nextTokenId++;
            }
        }
    }
}

