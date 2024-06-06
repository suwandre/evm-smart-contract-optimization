// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV24 {
    bytes32 public hash;

    function readHash() public view returns (bytes32) {
        return hash;
    }
}