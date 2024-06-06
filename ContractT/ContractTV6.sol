// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractTV6 {
    uint256 private count;

    function increment() public {
        // increments by 2 instead of 1 in `ContractTV5`
        count += 2;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}
