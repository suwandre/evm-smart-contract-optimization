// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract UUPSProxy {
    // slot designated to store the address of the implementation contract
    // obtained via `keccak256("uups.proxy.address")` subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0xc9f6ead2bbe8230e30f7cb88f9886a9298621e2a962ffe313c3ae99d68652039;

    constructor(address _logic) {
        _setImplementation(_logic);
    }

    function _setImplementation(address newImplementation) private {
        bytes32 slot = _IMPLEMENTATION_SLOT;
        assembly {
            sstore(slot, newImplementation)
        }
    }

    // gets the current implementation address from the implementation slot
    function getImplementation() public view returns (address impl) {
        assembly {
            impl := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function _delegate(address _impl) internal {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    fallback() external payable {
        _delegate(getImplementation());
    }

    receive() external payable {}
}