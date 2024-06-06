// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol";

// simple marketplace listing contract mimicking opensea's extensive functionality
contract ContractWV3 {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bytes32 salt;
    }

    // obtained via `keccak256("ListingCreated(bytes32, address)")`
    bytes32 private constant _LISTING_CREATED_EVENT_SIGNATURE = 0x17a154a37f0fb7c7f440e4672a098f6afcc1ba29bc7ab9ce143014be49d7410e;
    // obtained via `keccak256("ListingCancelled(bytes32, address)")`
    bytes32 private constant _LISTING_CANCELLED_EVENT_SIGNATURE = 0x13c3e2105d66aef65e187710d248703d9b145a13fc06330bcec2d4481ad0da10;
    // obtained via `keccak256("ListingPurchased(bytes32, address)")`
    bytes32 private constant _LISTING_PURCHASED_EVENT_SIGNATURE = 0x4c72f34d0e2a0b597a25ae9c086c06c4ac48ba071ecc23757ab1668bcd20be50;
    
    mapping (bytes32 => Listing) private listings;

    error InvalidSeller();
    error InvalidBuyer();
    error ListingAlreadyCancelled(bytes32 listingHash);
    error NotOwner(uint256 tokenId);
    error ListingNotFound(bytes32 listingHash);
    error InvalidListing(bytes32 listingHash);
    error InvalidAmountToPay(bytes32 listingHash, uint256 price, uint256 amountToPay);

    modifier onlyOwner(uint256 tokenId, address nftContract) {
        _checkNFTOwned(tokenId, nftContract);

        _;
    }

    modifier onlySeller(bytes32 listingHash) {
        _checkIfSeller(listingHash);

        _;
    }

    function createListing(
        uint256 tokenId,
        address nftContract,
        bytes32 salt,
        uint256 price
    ) external onlyOwner(tokenId, nftContract) {
        bytes32 listingHash = getListingHash(tokenId, msg.sender, price, nftContract, salt);

        listings[listingHash] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            price: price,
            salt: salt
        });

        assembly {
            log3(
                0,
                0,
                _LISTING_CREATED_EVENT_SIGNATURE,
                listingHash,
                caller()
            )
        }
    }

    // since empty listings have address(0) as the seller, we don't need an extra modifier to check
    // if the listing actually exists. if `onlySeller` passes, it's assumed the listing does exist.
    function cancelListing(bytes32 listingHash) external onlySeller(listingHash) {
        delete listings[listingHash];

        assembly {
            log2(
                0,
                0,
                listingHash,
                caller()
            )
        }
    }

    function changeListingPrice(bytes32 listingHash, uint256 price) external onlySeller(listingHash) {
        listings[listingHash].price = price;
    }

    function buy(bytes32 listingHash, address nftContract) external payable {
        Listing memory listing = listings[listingHash];

        _checkValidListing(listingHash);
        _checkValidBuyer(listingHash);
        _checkValidAmountToPay(listingHash);

        IERC721A(nftContract).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        payable(listing.seller).transfer(msg.value);

        delete listings[listingHash];
        
        assembly {
            log3(
                0,
                0,
                _LISTING_PURCHASED_EVENT_SIGNATURE,
                listingHash,
                caller()
            )
        }
    }

    function getListingHash(
        uint256 tokenId,
        address seller,
        uint256 price,
        address nftContract,
        bytes32 salt
    ) public pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                tokenId,
                seller,
                price,
                nftContract,
                salt
            )
        );
    }

    function _checkNFTOwned(uint256 tokenId, address nftContract) private view {
        if (IERC721A(nftContract).ownerOf(tokenId) != msg.sender) revert NotOwner(tokenId);
    }

    function _checkIfSeller(bytes32 listingHash) private view {
        if (listings[listingHash].seller != msg.sender) revert InvalidSeller();
    }

    function _checkValidListing(bytes32 listingHash) private view {
        if (listings[listingHash].seller == address(0)) revert ListingNotFound(listingHash);
    }

    function _checkValidBuyer(bytes32 listingHash) private view {
        if (listings[listingHash].seller == msg.sender) revert InvalidBuyer();
    }

    function _checkValidAmountToPay(bytes32 listingHash) private view {
        if (msg.value != listings[listingHash].price) revert InvalidAmountToPay(listingHash, listings[listingHash].price, msg.value);
    }
}