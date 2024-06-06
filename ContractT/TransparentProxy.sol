//SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract TransparentProxy {
    address public immutable admin;
    // slot designated to store the address of the implementation contract
    // obtained via `keccak256("transparent.proxy.address")` subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0xdf0301707cd2eac22558a676ee6d7958362cf6a2c87f850f5db407cdcc2b4db3;

    error NotAdmin();

    modifier onlyAdmin() {
        _checkAdmin();
        _;
    }

    constructor(address _logic, address _admin) {
        admin = _admin;
        _setImplementation(_logic);
    }

    function _setImplementation(address newImplementation) private {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    // gets the current implementation address from the implementation slot
    function getImplementation() public view returns (address impl) {
        assembly {
            impl := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function upgrade(address newImplementation) external onlyAdmin {
        _setImplementation(newImplementation);
    }

    function _checkAdmin() private view {
        if (msg.sender != admin) revert NotAdmin();
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