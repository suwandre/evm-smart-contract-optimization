// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "./ContractACV3.sol";

contract ContractACV5 is ContractACV3 {
    function addV5(uint256 x, uint256 y) internal pure returns (uint256) {
        return add(x, y);
    }
}
