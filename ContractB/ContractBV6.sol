// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV6 {
    uint128 public num;

    function readNumber() public view returns (uint128) {
        return num;
    }
}