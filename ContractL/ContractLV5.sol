// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractLV5 {
    struct Item {
        uint256 id;
        string name;
        string description;
    }

    mapping (uint256 => Item) public items;

    // we assume that the index of each array corresponds to an item.
    // e.g. `ids[0]`, `names[0]` and `description[0]` belongs to one item.
    function addItems(uint256[] calldata ids, string[] calldata names, string[] calldata descriptions) public {
        for (uint256 i = 0; i < ids.length; i++) {
            items[ids[i]] = Item({
                id: ids[i],
                name: names[i],
                description: descriptions[i]
            });
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