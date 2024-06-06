// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV32 {
    int256 public num;

    function readNum() public view returns (int128) {
        return int128(num);
    }
}