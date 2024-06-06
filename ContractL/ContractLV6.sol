// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV6 {
    struct Item {
        uint256 id;
        string name;
        string description;
    }

    mapping (uint256 => Item) public items;

    function addItems(Item[] calldata _items) public {
        for (uint256 i = 0; i < _items.length; i++) {
            items[_items[i].id] = _items[i];
        }
    }

    function updateDescriptions(uint256[] calldata ids, string[] calldata descriptions) public {
        for (uint256 i = 0; i < ids.length; i++) {
            Item storage item = items[ids[i]];

            item.description = descriptions[i];
        }
    }

    function getItem(uint256 id) public view returns (Item memory) {
        return items[id];
    }
}