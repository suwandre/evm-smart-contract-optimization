// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV1 {
    function addTimestamp(uint256 time) public view returns (uint256) {
        uint256 currentTimestamp = block.timestamp;

        return time + currentTimestamp;
    }
}