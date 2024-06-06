// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractIV9 {
    struct Person {
        string name;
        // declaring `uint256` for age is cheaper than `uint8`
        // although logically not needed, since `uint8` allows up to age 255.
        uint256 age;
    }

    mapping (uint256 => Person) public person;
}