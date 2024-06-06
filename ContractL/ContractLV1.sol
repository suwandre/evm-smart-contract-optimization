// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV1 {
    function sum(
        uint256 a, 
        uint256 b, 
        uint256 c,
        uint256 d,
        uint256 e
    ) public pure returns (uint256) {
        return a + b + c + d + e;
    }
}