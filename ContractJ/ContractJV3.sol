// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractJV3 {
    function deposit() public payable {
        // normally, you can add events or any other form of logic here.
        // however, since we only care about depositing, having this function marked `payable` is enough.
        // the rest of this function is essentially empty.    
    }
    function withdraw() public {
        address recipient = msg.sender;

        payable(recipient).transfer(address(this).balance);
    }
}