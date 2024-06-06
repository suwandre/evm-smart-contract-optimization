// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractEV4 {
    uint256 private immutable num1 = 1;
    
    function getNum1() public pure returns (uint256) {
        return num1;
    }

    constructor() {
        num1 = 2;
    }
}