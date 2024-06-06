// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

interface IDiamondCut {
    enum FacetCutAction { Add, Replace, Remove }
    
    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    function diamondCut(FacetCut[] calldata _facetCuts, address _init, bytes calldata _data) external;
}