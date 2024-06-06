// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ContractSV3 is ERC1155 {
    // custom error
    error InvalidQuantity();

    // the next token ID to mint
    uint256 private _nextTokenId;

    // test API (not a real URI), just for showing purposes
    constructor() ERC1155("https://api.test.com/{id}.json") {}

    function batchMint(address to, uint256 quantity) public {
        if (quantity == 0) revert InvalidQuantity();

        uint256[] memory ids = new uint256[](quantity);
        uint256[] memory amounts = new uint256[](quantity);

        unchecked {
            uint256 currentTokenId = _nextTokenId;
            uint256 endTokenId = currentTokenId + quantity;

            assembly {
                // pointer to first element of `ids`
                let idsPtr := add(ids, 32)
                // pointer to first element of `amounts`
                let amountsPtr := add(amounts, 32)

                for { let i := currentTokenId } lt(i, endTokenId) { i := add(i, 1) } {
                    // store currentTokenId in `ids`
                    mstore(idsPtr, i)
                    // store 1 in `amounts` (since each is an NFT)
                    mstore(amountsPtr, 1)
                    // move pointer to next element in `ids`
                    idsPtr := add(idsPtr, 32)
                    // move pointer to next element in `amounts`
                    amountsPtr := add(amountsPtr, 32)
                }
            }

            _nextTokenId = endTokenId;
        }

        // mint all nfts in a single transaction
        _mintBatch(to, ids, amounts, "");
    }
}

