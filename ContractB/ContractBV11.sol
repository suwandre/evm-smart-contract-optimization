// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV11 {
    uint256 public num;

    function readNumber() public view returns (uint248) {
        return uint248(num);
    }
}