// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV2 {
    function addTimestamp(uint256 time) public view returns (uint256) {
        return time + block.timestamp;
    }
}