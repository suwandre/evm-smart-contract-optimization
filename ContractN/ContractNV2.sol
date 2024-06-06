// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractNV2 {
    struct Item {
        uint256 id;
        bytes32 name;
        bytes32 description;
    }

    mapping (uint256 => Item) public items;

    modifier isValidItem(uint256 _id, bytes32 _name, bytes32 _description) {
        require(items[_id].name == bytes32(0), "Item already exists");
        require(_name != bytes32(0), "Item doesn't have a valid name");
        require(_description != bytes32(0), "Item doesn't have a valid description");

        _;
    }

    modifier itemExists(uint256 _id) {
        require(items[_id].name != bytes32(0), "Item doesn't exist");

        _;
    }

    modifier isValidDescription(bytes32 _description) {
        require(_description != bytes32(0), "Item doesn't have a valid description");

        _;
    }

    function addItems(Item[] calldata _items) public {
        for (uint256 i = 0; i < _items.length; i++) {
           addItem(_items[i]);
        }
    }

    function updateDescriptions(uint256[] calldata ids, bytes32[] calldata descriptions) public {
        for (uint256 i = 0; i < ids.length; i++) {
            updateDescription(ids[i], descriptions[i]);
        }
    }

    function getItem(uint256 id) public view returns (Item memory) {
        return items[id];
    }

    function addItem(Item calldata _item) private isValidItem(_item.id, _item.name, _item.description) {
        items[_item.id] = _item;
    }

    function updateDescription(uint256 _id, bytes32 _description) private itemExists(_id) isValidDescription(_description) {
        Item storage item = items[_id];

        item.description = _description;
    }
}
