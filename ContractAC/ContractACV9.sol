// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractACV9 {
    // event signature for emitting the `Add` event
    // similar to `emit Add(uint256 x, uint256 y)`, but hashed using `keccak256("Add(uint256, uint256)")`
    bytes32 private constant _ADD_EVENT_SIGNATURE = 0x8ee47376d9c2ec9db9d101531c6bb7e908bd232d71958da5feb9ca0a0c8c8357;
    function add(uint256 x, uint256 y) external pure returns (uint256 sum) {
        assembly {
            sum := add(x, y)
        }
    }

    function addAndEmitEvent(uint256 x, uint256 y) external {
        this.add(x, y);

        assembly {
            // `log3` emits the event via assembly
            log3(0, 0, _ADD_EVENT_SIGNATURE, x, y)
        }
    }
}
