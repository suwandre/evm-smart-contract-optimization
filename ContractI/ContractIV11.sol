// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractIV11 {
    struct Person {
        string name;
        // declaring `uint256` for age is cheaper than `uint8`
        // although logically not needed, since `uint8` allows up to age 255.
        uint256 age;
    }

    // a nested mapping of `People`
    // an example would be grouping organizations or ethnicity into specific indexes.
    mapping (uint256 => mapping (uint256 => Person)) public people;
}