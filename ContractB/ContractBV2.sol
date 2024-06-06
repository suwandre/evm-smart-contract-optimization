// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractBV2 {
    uint8 internal num;

    function readNumber() public view returns (uint88) {
        return num;
    }
}