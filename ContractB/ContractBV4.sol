// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV4 {
    uint128 public num;

    function readNumber() public view returns (uint8) {
        return uint8(num);
    }
}