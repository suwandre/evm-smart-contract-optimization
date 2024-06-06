// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractCV6 {
    uint256 private num;

    uint8 private constant B_POS = 8;
    uint8 private constant C_POS = 16;
    uint8 private constant D_POS = 32;
    uint8 private constant E_POS = 48;
    uint8 private constant F_POS = 80;
    uint8 private constant G_POS = 144;

    uint256 private constant A_MASK = (1 << 8) - 1;
    uint256 private constant B_MASK = (1 << 8) - 1 << B_POS;
    uint256 private constant C_MASK = (1 << 16) - 1 << C_POS;
    uint256 private constant D_MASK = (1 << 16) - 1 << D_POS;
    uint256 private constant E_MASK = (1 << 32) - 1 << E_POS;
    uint256 private constant F_MASK = (1 << 64) - 1 << F_POS;
    uint256 private constant G_MASK = (1 << 112) - 1 << G_POS;

    function setValues(
        uint8 a, 
        uint8 b, 
        uint16 c, 
        uint16 d, 
        uint32 e, 
        uint64 f, 
        uint112 g
    ) public {
        num = (uint256(a) & A_MASK) |
              (uint256(b) << B_POS) |
              (uint256(c) << C_POS) |
              (uint256(d) << D_POS) |
              (uint256(e) << E_POS) |
              (uint256(f) << F_POS) |
              (uint256(g) << G_POS);
    }

    function getValues() public view returns (
        uint8 a,
        uint8 b,
        uint16 c,
        uint16 d,
        uint32 e,
        uint64 f,
        uint112 g
    ) {
        a = uint8(num & A_MASK);
        b = uint8((num & B_MASK) >> B_POS);
        c = uint16((num & C_MASK) >> C_POS);
        d = uint16((num & D_MASK) >> D_POS);
        e = uint32((num & E_MASK) >> E_POS);
        f = uint64((num & F_MASK) >> F_POS);
        g = uint112((num & G_MASK) >> G_POS);
    }
}