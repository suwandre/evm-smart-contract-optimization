// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractEV6 {
    uint256 private constant num1 = 1;
    uint256 private immutable num2 = 1;
    
    function getNum1() public pure returns (uint256) {
        return num1;
    }

    function getNum2() public pure returns (uint256) {
        return num2;
    }
}