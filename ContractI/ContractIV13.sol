// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractIV13 {
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
        // uses the pop() method, so we will have to move all elements after the to-be-removed element
        // one index back.
        for (uint256 i = index; i < people.length - 1; i++) {
            people[i] = people[i + 1];
        }

        people.pop();
    }
}