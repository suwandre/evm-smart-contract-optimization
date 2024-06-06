// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractKV5 {
    struct Student {
        uint256 id;
        string name;
        uint256 age;
        uint256 averageScore;
    }

    mapping (uint256 => Student) public students;

    function addStudents(Student[] calldata _students) public {
        for (uint256 i = 0; i < _students.length; i++) {
            // assuming each entry is unique (for simplicity purposes)
            students[_students[i].id] = _students[i];
        }
    }

    // we are assuming that each index corresponds to a student.
    // for instance, ids[0] and scores[0] should correspond to one student and so on.
    function updateAverageScore(uint256[] calldata ids, uint256[] calldata scores) public {
        for (uint256 i = 0; i < ids.length; i++) {
            Student storage student = students[ids[i]];

            student.averageScore = scores[i];
        }
    }
}