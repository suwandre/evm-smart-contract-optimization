// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV14 {
    bytes1 public hash;

    function readHash() public view returns (bytes31) {
        return hash;
    }
}