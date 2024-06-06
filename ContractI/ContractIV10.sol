// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractIV10 {
    struct Person {
        string name;
        // declaring `uint256` for age is cheaper than `uint8`
        // although logically not needed, since `uint8` allows up to age 255.
        uint256 age;
    }

    // a nested array of `Person`
    // an example would be grouping organizations or ethnicity into specific indexes.
    Person[][] public people;
}