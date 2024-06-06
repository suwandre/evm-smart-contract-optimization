// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV22 {
    bytes32 public hash;

    function readHash() public view returns (bytes16) {
        return bytes16(hash);
    }
}