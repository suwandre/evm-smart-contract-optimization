// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractQV2 {
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
        assembly {
            sstore(value.slot, 0)
        }
    }

    // clears the balance of `balances[addr]`, effectively zeroing the storage slot
    function clearBalance(address addr) public {
        assembly {
            // stores `addr` into memory starting at position 0 (0x0)
            mstore(0x0, addr)
            // stores slot number of the `balances` mapping into the next 32 bytes of memory starting at position 32 (0x20)
            mstore(0x20, balances.slot)
            // `keccak256(0, 0x40) calculates the keccak256 hash of the data in memory from position 0 to 63 (0x0 to 0x3F)
            // this includes both `addr` stored in 0x0 to 0x1F (i.e. bytes 0 - 31) and the mapping slot number stored from 0x20 to 0x3F (i.e. bytes 32 - 63).
            // the hash of these two results in the final storage slot of `balances[addr]` in the storage layout.
            // it then gets stored with a value of `0` via `sstore`.
            sstore(keccak256(0, 0x40), 0)
        }
    }
}
