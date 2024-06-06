// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV10 {
    uint256 public num;

    function readNumber() public view returns (uint128) {
        return uint128(num);
    }
}