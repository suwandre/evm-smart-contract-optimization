// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MessageHashUtils.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol";

// simple marketplace listing contract mimicking opensea's extensive functionality
contract ContractWV2 {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
    }

    // emits the `ListingCancelled` event
    // obtained via `keccak256("ListingCancelled(bytes32, address)")`
    bytes32 private constant _LISTING_CANCELLED_EVENT_SIGNATURE = 0x13c3e2105d66aef65e187710d248703d9b145a13fc06330bcec2d4481ad0da10;
    
    // emits the `ListingPurchased` event
    // obtained via `keccak256("ListingPurchased(bytes32, address)")`
    bytes32 private constant _LISTING_PURCHASED_EVENT_SIGNATURE = 0x4c72f34d0e2a0b597a25ae9c086c06c4ac48ba071ecc23757ab1668bcd20be50;

    // mapping from listing hash to boolean
    mapping (bytes32 => bool) public cancelledListings;

    error InvalidSignature(bytes signature, address recoveredAddress, address expectedAddress);
    error InvalidBuyer();
    error InvalidSeller();
    error InvalidListing(bytes32 listingHash);
    error InvalidAmountToPay(uint256 price, uint256 amountToPay);
    error ListingAlreadyCancelled(bytes32 listingHash);

    function buy(
        // [0] -> tokenId
        // [1] -> price
        uint256[2] calldata nums,
        // [0] -> seller
        // [1] -> nftContract
        address[2] calldata addrs,
        bytes32 salt,
        // the seller's signature
        bytes calldata signature
    ) external payable {
        bytes32 listingHash = getListingHash(nums[0], addrs[0], nums[1], addrs[1], salt);
        
        _checkValidSignature(addrs[0], listingHash, signature);
        _checkValidBuyer(addrs[0]);
        _checkValidListing(
            listingHash
        );
        _checkValidAmountToPay(nums[1], msg.value);

        IERC721A(addrs[1]).safeTransferFrom(addrs[0], msg.sender, nums[0]);

        payable(addrs[0]).transfer(msg.value);

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

    // can only be called by `seller` given that the seller's signature is required
    function cancelListing(
        bytes32 listingHash,
        // the seller's signature
        bytes calldata signature
    ) external {
        _checkValidSignature(msg.sender, listingHash, signature);
        _checkUncancelledListing(listingHash);

        cancelledListings[listingHash] = true;

        assembly {
            log3(
                0,
                0,
                _LISTING_CANCELLED_EVENT_SIGNATURE,
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

    function _checkValidSignature(
        address seller,
        bytes32 listingHash,
        bytes calldata signature
    ) private pure {
        address recoveredAddress = ECDSA.recover(
            MessageHashUtils.toEthSignedMessageHash(
                listingHash
            ),
            signature
        );

        if (recoveredAddress != seller) revert InvalidSignature(signature, recoveredAddress, seller);
    }

    function _checkValidBuyer(address seller) private view {
        if (seller == msg.sender) revert InvalidBuyer();
    }

    function _checkValidListing(bytes32 listingHash) private view {
        if (cancelledListings[listingHash]) revert InvalidListing(listingHash);
    }

    function _checkValidAmountToPay(uint256 price, uint256 amountToPay) private pure {
        if (price != amountToPay) revert InvalidAmountToPay(price, amountToPay);
    }

    function _checkUncancelledListing(bytes32 listingHash) private view {
        if (cancelledListings[listingHash]) revert ListingAlreadyCancelled(listingHash);
    }
}