// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV8 {
    uint256 public count;

    function incrementCount() public {
        uint256 tempCount;

        for (uint256 i = 0; i < 20; i++) {
            tempCount += i;
        }

        count += tempCount;
    }
}