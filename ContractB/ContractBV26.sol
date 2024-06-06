// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV26 {
    int8 public num;

    function readNum() public view returns (int248) {
        return num;
    }
}