// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV17 {
    bytes16 public hash;

    function readHash() public view returns (bytes15) {
        return bytes15(hash);
    }
}