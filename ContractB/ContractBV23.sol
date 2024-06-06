// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV23 {
    bytes32 public hash;

    function readHash() public view returns (bytes31) {
        return bytes31(hash);
    }
}