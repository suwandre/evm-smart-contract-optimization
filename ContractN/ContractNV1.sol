// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractNV1 {
    struct Item {
        uint256 id;
        bytes32 name;
        bytes32 description;
    }

    mapping (uint256 => Item) public items;

    function addItems(Item[] calldata _items) public {
        for (uint256 i = 0; i < _items.length; i++) {
            // sample require statement to check whether an item with the specific id already exists in `items`
            require(items[_items[i].id].name == bytes32(0), "Item already exists");
            // sample require statement to check whether the item should have a valid name
            require(_items[i].name != bytes32(0), "Item doesn't have a valid name");
            // sample require statement to check whether the item should have a valid description
            require(_items[i].description != bytes32(0), "Item doesn't have a valid description");

            items[_items[i].id] = _items[i];
        }
    }

    function updateDescriptions(uint256[] calldata ids, bytes32[] calldata descriptions) public {
        for (uint256 i = 0; i < ids.length; i++) {
            // sample require statement to check whether the description for this item exists in `descriptions`
            require(descriptions[i] != bytes32(0), "Item doesn't have a valid description");

            Item storage item = items[ids[i]];

            // sample require statement to check whether the item with the given id exists
            require(item.name != bytes32(0), "Item doesn't exist");

            item.description = descriptions[i];
        }
    }

    function getItem(uint256 id) public view returns (Item memory) {
        return items[id];
    }
}

