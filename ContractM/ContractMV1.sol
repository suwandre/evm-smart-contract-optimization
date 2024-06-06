// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractMV1 {
    function sumNumbers(uint256[] calldata nums) public pure returns (uint256) {
        uint256 sum;

        unchecked {
            for (uint256 i = 0; i < nums.length; i++) {
                sum += nums[i];
            }
        }

        return sum;
    }
}