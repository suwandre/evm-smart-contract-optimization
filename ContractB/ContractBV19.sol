// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV19 {
    bytes16 public hash;

    function readHash() public view returns (bytes31) {
        return hash;
    }
}