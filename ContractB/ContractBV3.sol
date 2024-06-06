// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV3 {
    uint8 public num;

    function readNumber() public view returns (uint256) {
        return num;
    }
}