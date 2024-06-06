// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV28 {
    int128 public num;

    function readNum() public view returns (int8) {
        return int8(num);
    }
}