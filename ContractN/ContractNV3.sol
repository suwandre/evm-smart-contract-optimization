// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractNV3 {
    struct Item {
        uint256 id;
        bytes32 name;
        bytes32 description;
    }

    mapping (uint256 => Item) public items;

    modifier isValidItem(uint256 _id, bytes32 _name, bytes32 _description) {
        _checkValidItem(_id, _name, _description);

        _;
    }

    modifier itemExists(uint256 _id) {
        _checkItemExists(_id);

        _;
    }

    modifier isValidDescription(bytes32 _description) {
        _checkValidDescription(_description);

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

    function _checkValidItem(uint256 _id, bytes32 _name, bytes32 _description) internal view {
        require(items[_id].name == bytes32(0), "Item already exists");
        require(_name != bytes32(0), "Item doesn't have a valid name");
        require(_description != bytes32(0), "Item doesn't have a valid description");
    }

    function _checkItemExists(uint256 _id) internal view {
        require(items[_id].name != bytes32(0), "Item doesn't exist");
    }

    function _checkValidDescription(bytes32 _description) internal pure {
        require(_description != bytes32(0), "Item doesn't have a valid description");
    }
}
