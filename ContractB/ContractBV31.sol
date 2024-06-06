// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV31 {
    int256 public num;

    function readNum() public view returns (int8) {
        return int8(num);
    }
}