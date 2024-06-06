// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV16 {
    bytes16 public hash;

    function readHash() public view returns (bytes1) {
        return bytes1(hash);
    }
}