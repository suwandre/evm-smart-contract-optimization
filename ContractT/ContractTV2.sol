// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractTV2 {
    uint256 private count;

    function increment() public {
        // changed to an increment of 2 instead of 1 in `TV1`
        count += 2;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}
