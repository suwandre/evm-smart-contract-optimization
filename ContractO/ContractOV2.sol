// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractOV2 {
    mapping (address => bool) public hasPerms;
    mapping (address => uint256) public balances;

    // a constructor is declared to initially provide permission to `msg.sender` and
    // give `msg.sender` an arbitrary balance of 10,000 units.
    constructor() {
        balances[msg.sender] = 10000;
    }

    function setPerms(address addr, bool perms) public {
        hasPerms[addr] = perms;
    }

    function setBalance(address addr, uint256 balance) public {
        balances[addr] = balance;
    }

    function sendBalance(address to, uint256 amount) public {
        // in this scenario, permission checking has a higher priority than having enough balance,
        // so in `short-circuiting` fashion, permission checking is placed first.
        if (!hasPerms[msg.sender] || balances[msg.sender] < amount) {
            revert("No perms/not enough balance");
        }

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
