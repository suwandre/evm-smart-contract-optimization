// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractPV2 {
    function add(uint256 x, uint256 y) public pure returns (uint256 sum) {
        assembly {
            sum := add(x, y)
        }
    }
}
