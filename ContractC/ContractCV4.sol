// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractCV4 {
    uint8 private a;
    uint8 private b;
    uint16 private c;
    uint16 private d;
    uint32 private e;
    uint64 private f;
    uint112 private g;

    // cheaper variant rather than just having setter functions for each variable.
    // however, users CANNOT pass in null values for variables they don't want to change.
    // hence, this will require users to pass in current values for variables they don't want to change.
    // for instance, if they want to change `a` and `b` but leave the rest as is, they need to input the current values of `c` to `g` as is.
    // this is hackier. an alternative is to have an individual setter function for each variable, but
    // since each transaction requires a base amount of gas to execute, overall deployment cost will be substantially higher, especially the more variables that exist.
    function setValues(
        uint8 _a,
        uint8 _b,
        uint16 _c,
        uint16 _d,
        uint32 _e,
        uint64 _f,
        uint112 _g
    ) public {
        a = _a;
        b = _b;
        c = _c;
        d = _d;
        e = _e;
        f = _f;
        g = _g;
    }

    // cheaper variant rather than just having getter functions for each variable.
    function getValues() public view returns (uint8, uint8, uint16, uint16, uint32, uint64, uint112) {
        return (a, b, c, d, e, f, g);
    }
}