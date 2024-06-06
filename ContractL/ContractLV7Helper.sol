// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV7Helper {
    function stringToBytes32(string calldata str) public pure returns (bytes32) {
        return bytes32(abi.encodePacked(str));
    }

    function bytes32ToString(bytes32 str) public pure returns (string memory) {
        return string(abi.encodePacked(str));
    }
}