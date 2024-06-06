// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV5 {
    function deposit() public payable {
        // normally, you can add events or any other form of logic here.
        // however, since we only care about depositing, having this function marked `payable` is enough.
        // the rest of this function is essentially empty.    
    }

    function withdraw() public {
        payable(msg.sender).transfer(0.01 ether);
        payable(0x2175cF248625c4cBefb204E76f0145b47d9061F8).transfer(0.005 ether);
    }
}