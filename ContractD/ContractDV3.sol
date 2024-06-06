// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractDV3 {
    uint256 private num1;
    uint256 private num2;
    uint256 private num3;
    uint256 private num4;
    uint256 private num5;
    uint256 private num6;
    bytes32 private hash1;
    bytes32 private hash2;
    bytes4 private hash3;
    bytes1 private hash4;
    bytes16 private hash5;
    string private str1;
    string private str2;
    bool private bool1;
    bool private bool2;

     function getNum1() public view returns (uint256) {
        return num1;
    }

    function getNum2() public view returns (uint256) {
        return num2;
    }

    function getNum3() public view returns (uint256) {
        return num3;
    }

    function getNum4() public view returns (uint256) {
        return num4;
    }

    function getNum5() public view returns (uint256) {
        return num5;
    }

    function getNum6() public view returns (uint256) {
        return num6;
    }

    function getHash1() public view returns (bytes32) {
        return hash1;
    }

    function getHash2() public view returns (bytes32) {
        return hash2;
    }

    function getHash3() public view returns (bytes4) {
        return hash3;
    }

    function getHash4() public view returns (bytes1) {
        return hash4;
    }

    function getHash5() public view returns (bytes16) {
        return hash5;
    }

    function getStr1() public view returns (string memory) {
        return str1;
    }

    function getStr2() public view returns (string memory) {
        return str2;
    }

    function getBool1() public view returns (bool) {
        return bool1;
    }

    function getBool2() public view returns (bool) {
        return bool2;
    }
}