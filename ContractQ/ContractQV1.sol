// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractQV1 {
    uint256 private value;
    mapping (address => uint256) private balances;

    function getValue() public view returns (uint256) {
        return value;
    }

    function getBalance(address addr) public view returns (uint256) {
        return balances[addr];
    }

    function setValue(uint256 _value) public {
        value = _value;
    }

    function setBalance(address addr, uint256 balance) public {
        balances[addr] = balance;
    }

    // clears `value`, effectively zeroing the storage slot
    function clearValue() public {
        value = 0;
    }

    // clears the balance of `balances[addr]`, effectively zeroing the storage slot
    function clearBalance(address addr) public {
        delete balances[addr];
    }
}
