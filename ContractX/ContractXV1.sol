// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "./ERC721AExtended.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";

contract ContractXV1 is ERC721AExtended, AccessControl {
    // max supply of NFT is 5000
    uint256 private constant MAX_SUPPLY = 5000;
    mapping (address => bool) private whitelisted;

    constructor() ERC721A("Test Token", "TTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    error NotWhitelisted();
    error MaxSupplyLimitReached();
    error AlreadyMinted();

    modifier onlyWhitelisted() {
        _checkWhitelisted();
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

    function checkWhitelisted(address addr) external view returns (bool) {
        return whitelisted[addr];
    }

    // if `add` is true, then it's to add addresses to the whitelist. if false, then to remove.
    function handleWhitelist(address[] calldata addrs, bool add) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // convert `add` to an integer instance used to store into storage
        uint256 addInt = add ? 1 : 0;

        assembly {
            let len := addrs.length
            let addrsPtr := addrs.offset

            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let addr := calldataload(addrsPtr)
                mstore(0x0, addr)
                mstore(0x20, whitelisted.slot)
                let hash := keccak256(0x0, 0x40)
                sstore(hash, addInt)

                addrsPtr := add(addrsPtr, 0x20)
            }
        }
    }

    function whitelistMint() external onlyWhitelisted hasNotMinted isBelowMaxSupply {
        _setAux(_msgSender(), 1);
        _safeMint(_msgSender(), 1);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _checkWhitelisted() private view {
        if (!whitelisted[_msgSender()]) revert NotWhitelisted();
    }

    function _checkBelowMaxSupply() private view {
        if (totalSupply() + 1 > MAX_SUPPLY) revert MaxSupplyLimitReached();
    }

    // assumes a whitelisted participant can only mint once
    function _checkHasNotMinted() private view {
        if (_getAux(_msgSender()) >= 1) revert AlreadyMinted();
    }
}
