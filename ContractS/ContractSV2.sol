// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "erc721a/contracts/ERC721A.sol";

contract ContractSV2 is ERC721A {
    constructor() ERC721A("Test Token", "TTK") {}

    function batchMint(address to, uint256 quantity) public {
        _safeMint(to, quantity);
    }
}

