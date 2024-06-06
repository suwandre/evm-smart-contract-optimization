// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractRV1 {
    function recoverSigner(bytes32 hash, bytes memory signature) public pure returns (address) {
        require(signature.length == 65, "Invalid sig length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        // split `signature` into `r`, `s` and `v`
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // adjust v if it's in a wrong range
        if (v < 27) {
            v += 27;
        }

        return ecrecover(hash, v, r, s);
    }
}

