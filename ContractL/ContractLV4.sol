// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV4 {
    function sum(uint256 packedData) public pure returns (uint256 total) {
        // we are assuming here that variables `a`, `b`, `c`, `d` and `e` can fit into a single uint256 through the following:
        // `a` to `d`: 48 bits each (uint48)
        // `e`: 64 bits (uint64)
        return ((packedData & ((1 << 48) - 1)) +                   
                ((packedData >> 48) & ((1 << 48) - 1)) +          
                ((packedData >> 96) & ((1 << 48) - 1)) +        
                ((packedData >> 144) & ((1 << 48) - 1)) +          
                (packedData >> 192));           
    }
}