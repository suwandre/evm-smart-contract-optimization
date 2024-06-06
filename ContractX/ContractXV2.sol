// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "./ERC721AExtended.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol";

contract ContractXV2 is ERC721AExtended, AccessControl {
    // max supply of NFT is 5000
    uint256 private constant MAX_SUPPLY = 5000;
    bytes32 private merkleRoot;

    constructor() ERC721A("Test Token", "TTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    error NotWhitelisted();
    error MaxSupplyLimitReached();
    error AlreadyMinted();

    modifier onlyWhitelisted(bytes32[] calldata proof) {
        _checkWhitelisted(_msgSender(), proof);
        _;
    }

    modifier isBelowMaxSupply() {
        _checkBelowMaxSupply();
        _;
    }

    modifier hasNotMinted() {
        _checkHasNotMinted();
        _;
    }

    function getMerkleRoot() external view returns (bytes32 root) {
        assembly {
            root := sload(merkleRoot.slot)
        }
    }

    function setMerkleRoot(bytes32 root) external onlyRole(DEFAULT_ADMIN_ROLE) {
        assembly {
            sstore(merkleRoot.slot, root)
        }
    }

    function whitelistMint(bytes32[] calldata proof) external onlyWhitelisted(proof) hasNotMinted isBelowMaxSupply {
        _setAux(_msgSender(), 1);
        _safeMint(_msgSender(), 1);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // checks if an address is whitelisted
    function _checkWhitelisted(address addr, bytes32[] calldata proof) internal view {
        if (!_verify(_getLeaf(addr), proof)) revert NotWhitelisted();
    }
    
    // gets the leaf (i.e. hashed output of the address)
    function _getLeaf(address addr) internal pure returns (bytes32 leaf) {
        assembly {
            // loads the free memory pointer
            let ptr := mload(0x40)

            // stores the address to the memory pointer. since `mstore` stores 32 bytes and an address is only 20 bytes long (160 bits),
            // shifting the address 96 bits to the left pads it correctly for the keccak256 function.
            mstore(ptr, shl(0x60, addr))

            // computes the keccak256 hash of the 20 bytes (where `addr` is stored now) starting at `ptr`.
            leaf := keccak256(ptr, 0x14)
        }
    }

    // verifies the provided `proof` array to check if the user is whitelisted
    function _verify(bytes32 leaf, bytes32[] calldata proof) internal view returns (bool) {
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    function _checkBelowMaxSupply() private view {
        if (totalSupply() + 1 > MAX_SUPPLY) revert MaxSupplyLimitReached();
    }

    // assumes a whitelisted participant can only mint once
    function _checkHasNotMinted() private view {
        if (_getAux(_msgSender()) >= 1) revert AlreadyMinted();
    }
}
