// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractKV3 {
    function sumMultipleNumbers(uint256[] memory nums1, uint256[] memory nums2) public pure returns (uint256) {
        uint256 sum;

        // let's boldly assume that the length of nums1 is the same as nums2
        // such that we don't require an additional modifier to check if it does.
        for (uint256 i = 0; i < nums1.length; i++) {
            sum += (nums1[i] + nums2[i]);
        }
        
        return sum;
    }
}