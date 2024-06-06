// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV4 {
    function deposit() public payable {
        // normally, you can add events or any other form of logic here.
        // however, since we only care about depositing, having this function marked `payable` is enough.
        // the rest of this function is essentially empty.    
    }

    function withdraw() public {
        address recipientOne = msg.sender;
        // recipient two is another address of mine
        address recipientTwo = 0x2175cF248625c4cBefb204E76f0145b47d9061F8;

        // let's say we want to transfer 0.01 ether (in our case 0.01 tBNB) to `msg.sender`
        uint256 amountOne = 0.01 ether;
        // and we want to transfer 0.005 ether (in our case 0.005 tBNB) to `recipientTwo`
        uint256 amountTwo = 0.005 ether;

        // transfer `recipientOne` `amountOne`
        payable(recipientOne).transfer(amountOne);
        // transfer `recipientTwo` `amountTwo`
        payable(recipientTwo).transfer(amountTwo);
    }
}