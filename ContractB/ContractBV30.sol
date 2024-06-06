// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV30 {
    int128 public num;

    function readNum() public view returns (int128) {
        return num;
    }
}