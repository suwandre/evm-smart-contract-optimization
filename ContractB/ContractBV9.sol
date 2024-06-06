// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV9 {
    uint256 public num;

    function readNumber() public view returns (uint8) {
        return uint8(num);
    }
}