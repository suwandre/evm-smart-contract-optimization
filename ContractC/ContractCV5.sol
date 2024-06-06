// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractCV5 {
    uint8 private a;
    uint8 private b;
    uint16 private c;
    uint16 private d;
    uint32 private e;
    uint64 private f;
    uint112 private g;

    function setA(uint8 val) public {
        a = val;
    }

    function setB(uint8 val) public {
        b = val;
    }

    function setC(uint16 val) public {
        c = val;
    }

    function setD(uint16 val) public {
        d = val;
    }

    function setE(uint32 val) public {
        e = val;
    }

    function setF(uint64 val) public {
        f = val;
    }

    function setG(uint112 val) public {
        g = val;
    }

    // cheaper variant rather than just having getter functions for each variable.
    function getValues() public view returns (uint8, uint8, uint16, uint16, uint32, uint64, uint112) {
        return (a, b, c, d, e, f, g);
    }
}