// SPDX-License-Identifier: MIT

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol";

pragma solidity ^0.8.25;

abstract contract ERC721AExtended is ERC721AQueryable {
    function numberMinted(address _owner) external view returns (uint256) {
        return _numberMinted(_owner);
    }

    function totalMinted() external view returns (uint256) {
        return _totalMinted();
    }

    function totalBurned() external view returns (uint256) {
        return _totalBurned();
    }

    function nextTokenId() external view returns (uint256) {
        return _nextTokenId();
    }

    function getAux(address _owner) external view returns (uint64) {
        return _getAux(_owner);
    }

    function exists(uint256 _tokenId) external view returns (bool) {
        return _exists(_tokenId);
    }
}
