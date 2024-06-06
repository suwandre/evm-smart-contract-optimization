// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract SelectorCalculator {
    function getSelector(string calldata func) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(func)));
    }
}