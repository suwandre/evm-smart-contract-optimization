// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV33 {
    int256 public num;

    function readNum() public view returns (int240) {
        return int240(num);
    }
}