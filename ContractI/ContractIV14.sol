// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractIV14 {
    struct Person {
        string name;
        // declaring `uint256` for age is cheaper than `uint8`
        // although logically not needed, since `uint8` allows up to age 255.
        uint256 age;
    }

    uint256 private currentIndex;
    mapping (uint256 => Person) public person;

    function addPerson(string calldata name, uint256 age) public {
        person[currentIndex] = Person(name, age);

        currentIndex++;
    }

    function deletePerson(uint256 index) public {
        delete person[index];
    }
}