// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractACV4 {
    uint256 private num;

    uint8 private constant B_POS = 8;
    uint8 private constant C_POS = 16;
    uint8 private constant D_POS = 32;
    uint8 private constant E_POS = 48;
    uint8 private constant F_POS = 80;
    uint8 private constant G_POS = 144;

    // the difference between this and ContractCV7 is that the bit positions used for left shifting are explicitly declared.
    // this is because inline assembly only supports direct number constants and references to such constants.
    // using, for instance, `(1 << 8) - 1 << 8` instead of `(1 << 8) - 1 << B_POS` for `B_MASK` allows solidity
    // to evaluate them at compile time and treat them as direct constants.
    uint256 private constant A_MASK = (1 << 8) - 1;
    uint256 private constant B_MASK = (1 << 8) - 1 << 8;
    uint256 private constant C_MASK = (1 << 16) - 1 << 16;
    uint256 private constant D_MASK = (1 << 16) - 1 << 32;
    uint256 private constant E_MASK = (1 << 32) - 1 << 48;
    uint256 private constant F_MASK = (1 << 64) - 1 << 80;
    uint256 private constant G_MASK = (1 << 112) - 1 << 144;

    function setA(uint8 a) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(A_MASK)), a))
        }
    }

    function setB(uint8 b) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(B_MASK)), shl(B_POS, b)))
        }
    }

    function setC(uint16 c) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(C_MASK)), shl(C_POS, c)))
        }
    }

    function setD(uint16 d) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(D_MASK)), shl(D_POS, d)))
        }
    }

    function setE(uint32 e) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(E_MASK)), shl(E_POS, e)))
        }
    }

    function setF(uint64 f) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(F_MASK)), shl(F_POS, f)))
        }
    }

    function setG(uint112 g) external {
        assembly {
            sstore(num.slot, or(and(sload(num.slot), not(G_MASK)), shl(G_POS, g)))
        }
    }

    function getValues() external view returns (
        uint8 a,
        uint8 b,
        uint16 c,
        uint16 d,
        uint32 e,
        uint64 f,
        uint112 g
    ) {
        assembly {
            let n := sload(num.slot)
            
            a := and(n, A_MASK)
            b := shr(B_POS, and(n, B_MASK))
            c := shr(C_POS, and(n, C_MASK))
            d := shr(D_POS, and(n, D_MASK))
            e := shr(E_POS, and(n, E_MASK))
            f := shr(F_POS, and(n, F_MASK))
            g := shr(G_POS, and(n, G_MASK))
        }
    }
}