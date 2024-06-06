// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV2 {
    // dynamic array
    function sum(uint256[] calldata nums) public pure returns (uint256 total) {
        for (uint256 i = 0; i < nums.length; i++) {
            total += nums[i];
        }
    }
}