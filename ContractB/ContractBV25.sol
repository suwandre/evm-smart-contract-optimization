// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV25 {
    int8 public num;

    function readNum() public view returns (int8) {
        return num;
    }
}