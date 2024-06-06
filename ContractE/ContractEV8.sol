// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractEV8 {
    uint256 private num1 = 1;
    uint256 private num2 = 1;

    function getNum1() public view returns (uint256) {
        return num1;
    }

    function getNum2() public view returns (uint256) {
        return num2;
    }
}