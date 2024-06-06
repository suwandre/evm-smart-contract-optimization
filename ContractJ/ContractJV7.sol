// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV7 {
    uint256 public count;

    function incrementCount() public {
        for (uint256 i = 0; i < 20; i++) {
            count += i;
        }
    }
}