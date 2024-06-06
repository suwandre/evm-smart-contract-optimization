// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractIV12 {
    struct Person {
        string name;
        // declaring `uint256` for age is cheaper than `uint8`
        // although logically not needed, since `uint8` allows up to age 255.
        uint256 age;
    }

    Person[] public people;

    function addPerson(string calldata name, uint256 age) public {
        people.push(Person(name, age));
    }

    function deletePerson(uint256 index) public {
        // note: this will mess with the iteration of the array but is cheaper than
        // having to iterate and reshuffle the array to use .pop() for elements
        // not on the last index.
        delete people[index];
    }
}