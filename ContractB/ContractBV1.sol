// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV1 {
    uint8 public num;

    function readNumber() public view returns (uint8) {
        return num;
    }
}