// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV5 {
    uint128 public num;

    function readNumber() public view returns (uint120) {
        return uint120(num);
    }
}