// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV8 {
    uint128 public num;

    function readNumber() public view returns (uint256) {
        return num;
    }
}