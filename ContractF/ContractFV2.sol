// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractFV2 {
    uint256 private num = 0;

    function getNum() public view returns (uint256) {
        return num;
    }
}