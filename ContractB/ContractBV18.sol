// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV18 {
    bytes16 public hash;

    function readHash() public view returns (bytes16) {
        return hash;
    }
}