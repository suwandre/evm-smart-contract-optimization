// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV29 {
    int128 public num;

    function readNum() public view returns (int120) {
        return int120(num);
    }
}