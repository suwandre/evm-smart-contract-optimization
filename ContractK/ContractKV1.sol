// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractKV1 {
    function sumNumbers(uint256[] memory nums) public pure returns (uint256) {
        uint256 sum;

        for (uint256 i = 0; i < nums.length; i++) {
            sum += nums[i];
        }
        
        return sum;
    }
}