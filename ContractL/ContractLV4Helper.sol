// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV4Helper {
    // we are assuming `a` to `d` will fit in 48 bits (uint48) and `e` fits in 64 bits (uint64)
    function packValues(
        uint256 a,
        uint256 b,
        uint256 c,
        uint256 d,
        uint256 e 
    ) public pure returns (uint256 packedData) {
        require(a < (1 << 48), "a does not fit in 48 bits");
        require(b < (1 << 48), "b does not fit in 48 bits");
        require(c < (1 << 48), "c does not fit in 48 bits");
        require(d < (1 << 48), "d does not fit in 48 bits");
        require(e < (1 << 64), "e does not fit in 64 bits");

        packedData = (a |
                      (b << 48) |
                      (c << 96) |
                      (d << 144) |
                      (e << 192));
        return packedData;
    }
}
