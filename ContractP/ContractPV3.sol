// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractPV3 {
    function sumNumbers(uint256[] calldata nums) public pure returns (uint256 sum) {
        assembly {
            // load the length of the array from calldata
            let len := nums.length
            // get the starting position of the elements of `nums`
            let numsPtr := nums.offset

            for { let end := add(numsPtr, mul(len, 0x20)) } lt(numsPtr, end) { numsPtr := add(numsPtr, 0x20) } {
                // load each element directly from calldata and add to `sum`
                sum := add(sum, calldataload(numsPtr))
            }
        }
    }
}