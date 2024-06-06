// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractKV2 {
    function sumNumbers(uint256[] calldata nums) public pure returns (uint256) {
        uint256 sum;

        for (uint256 i = 0; i < nums.length; i++) {
            sum += nums[i];
        }
        
        return sum;
    }
}