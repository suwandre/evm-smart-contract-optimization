// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV7 {
    uint128 public num;

    function readNumber() public view returns (uint248) {
        return num;
    }
}