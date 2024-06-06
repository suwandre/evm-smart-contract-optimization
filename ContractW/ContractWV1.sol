// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MessageHashUtils.sol";

// single state channel transaction-based contract
contract ContractWV1 {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    address payable public participantA;
    address payable public participantB;

    mapping (address => uint256) private balances;

    constructor(address payable _participantA, address payable _participantB) {
        participantA = _participantA;
        participantB = _participantB;
    }
    
    error NotParticipant(address addr);
    error InsufficientBalance();
    error InvalidSignature(bytes signature, address recoveredAddress, address expectedAddress);

    function deposit() external payable {
        _checkParticipant(msg.sender);
        balances[msg.sender] += msg.value;
    }

    function getBalance(address participant) public view returns (uint256) {
        return balances[participant];
    }

    function settleChannel(
        // for each array, the 0th index should correspond to participant A
        // and the 1st index should correspond to participant B
        uint256[2] calldata amounts,
        bytes32[2] calldata salts,
        bytes[2] calldata signatures
    ) external {
        _checkEnoughBalance(amounts[0], amounts[1]);
        _verify(amounts, salts, signatures);

        unchecked {
            // this logic does NOT transfer `participantA`'s balance to `participantB`, hence why both balances are being deducted.
            // we're assuming that they're transferring to somewhere else (e.g. a merchant)
            balances[participantA] -= amounts[0];
            balances[participantB] -= amounts[1];
        }

        participantA.transfer(amounts[0]);
        participantB.transfer(amounts[1]);
    }

    function getTransactionHash(
        address participant,
        uint256 amount,
        bytes32 salt
    ) public pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                participant,
                amount,
                salt
            )
        );
    }

    function _verify(
        uint256[2] calldata amounts,
        bytes32[2] calldata salts,
        bytes[2] calldata signatures
    ) private view {
        address recoveredAddressA = ECDSA.recover(
                MessageHashUtils.toEthSignedMessageHash(
                    getTransactionHash(participantA, amounts[0], salts[0])
                ),
                signatures[0]
            );
        
        if (recoveredAddressA != participantA) revert InvalidSignature(signatures[0], recoveredAddressA, participantA);
        
        address recoveredAddressB = ECDSA.recover(
            MessageHashUtils.toEthSignedMessageHash(
                getTransactionHash(participantB, amounts[1], salts[1])
            ),
            signatures[1]
        );

        if (recoveredAddressB != participantB) revert InvalidSignature(signatures[1], recoveredAddressB, participantB);
    }

    function _checkParticipant(address addr) private view {
        if (addr != participantA && addr != participantB) revert NotParticipant(addr);
    }
 
    function _checkEnoughBalance(uint256 amountA, uint256 amountB) private view {
        if (amountA + amountB > balances[participantA] + balances[participantB]) revert InsufficientBalance();
    }
}