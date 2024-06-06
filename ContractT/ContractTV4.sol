// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractTV4 {
    // example immutable admin; doesn't have to be immutable if you think admin may change
    address private immutable admin;
    uint256 private count;

    // custom error
    error NotAdmin();

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        _checkAdmin();
        _;
    }

    function upgrade(address newImplementation) public onlyAdmin {
        _setImplementation(newImplementation);
    }

    function increment() public {
        // increments by 2 instead of 1 unlike `ContractTV3`
        count += 2;
    }

    function getCount() public view returns (uint256) {
        return count;
    }

    function _setImplementation(address newImplementation) internal {
        assembly {
            sstore(
                // the bytes32 hash for _IMPLEMENTATION_SLOT in `UUPSProxy`.
                0xc9f6ead2bbe8230e30f7cb88f9886a9298621e2a962ffe313c3ae99d68652039,
                newImplementation
            )
        }
    }

    function _checkAdmin() private view {
        if (msg.sender != admin) revert NotAdmin();
    }
}
