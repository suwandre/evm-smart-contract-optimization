// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractRV2 {
    function hashData(bytes calldata data) public pure returns (bytes32) {
        return sha256(data);
    }
}

