// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractEV7 {
    uint256 private num1 = 1;

    function getNum1() public view returns (uint256) {
        return num1;
    }
}