// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "./IDiamondCut.sol";
import "./DiamondProxy.sol";

contract DiamondCutFacet is IDiamondCut {
    DiamondProxy proxy;

    error InitFailed();

    constructor(address payable _proxy) {
        proxy = DiamondProxy(_proxy);
    }

    function diamondCut(
        FacetCut[] calldata _facetCuts,
        address _init,
        bytes calldata _data
    ) external {
        for (uint i = 0; i < _facetCuts.length; i++) {
            FacetCutAction action = _facetCuts[i].action;
            address facetAddress = _facetCuts[i].facetAddress;
            bytes4[] memory functionSelectors = _facetCuts[i].functionSelectors;

            for (uint j = 0; j < functionSelectors.length; j++) {
                if (action == FacetCutAction.Add || action == FacetCutAction.Replace) {
                    proxy.updateFacet(functionSelectors[j], facetAddress);
                } else if (action == FacetCutAction.Remove) {
                    proxy.updateFacet(functionSelectors[j], address(0));
                }
            }
        }

        if (_init != address(0)) {
            (bool success, ) = _init.delegatecall(_data);
            
            if (!success) revert InitFailed();
        }
    }
}