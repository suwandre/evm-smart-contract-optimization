// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV13 {
    bytes1 public hash;

    function readHash() public view returns (bytes1) {
        return hash;
    }
}