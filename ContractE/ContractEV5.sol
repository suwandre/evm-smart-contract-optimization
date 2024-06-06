// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractEV5 {
    uint256 private constant num1 = 1;
    
    function getNum1() public pure returns (uint256) {
        return num1;
    }
}