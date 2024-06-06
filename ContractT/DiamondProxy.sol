//SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract DiamondProxy {
    address public immutable admin;
    // slot designated to store the address of the diamond cut facet
    // obtained via `keccak256("diamond.cut.facet.slot")` subtracted by 1
    bytes32 private constant _DIAMOND_CUT_FACET_SLOT = 0x93caa8b49eae9c3c8dcf926991d37c523a5f666b25234b239367f1842c633b24;
    
    // maps a function selector to its facet address
    mapping(bytes4 => address) public facets;

    error Unauthorized();
    error InvalidFunction();

    constructor() {
        admin = msg.sender;
        setDiamondCutFacet(address(0));
    }

    modifier onlyAuthorized() {
        _checkAuthorized();

        _;
    }

    function updateFacet(bytes4 _selector, address _newFacetAddress) external onlyAuthorized {
        facets[_selector] = _newFacetAddress;
    }

    function setDiamondCutFacet(address _diamondCutFacet) public onlyAuthorized {
        assembly {
            sstore(_DIAMOND_CUT_FACET_SLOT, _diamondCutFacet)
        }
    }

    function getDiamondCutFacet() public view returns (address _diamondCutFacet) {
        assembly {
            _diamondCutFacet := sload(_DIAMOND_CUT_FACET_SLOT)
        }
    }

    fallback() external payable {
        address implementation = facets[msg.sig];
        if (implementation == address(0)) revert InvalidFunction();

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}

    function _checkAuthorized() internal view {
        if (msg.sender != admin && msg.sender != getDiamondCutFacet()) revert Unauthorized();
    }
}