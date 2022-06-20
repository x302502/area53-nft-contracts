// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract TokenERC721 is Ownable, Pausable, ERC721 {
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.UintSet;

    Counters.Counter public tokenIdTracker;
    string public baseUrl;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseUrl
    ) ERC721(_name, _symbol) {
        baseUrl = _baseUrl;
    }

    function setBaseUrl(string memory _baseUrl) public onlyOwner {
        baseUrl = _baseUrl;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address _to) external onlyOwner {
        tokenIdTracker.increment();
        uint256 tokenId = tokenIdTracker.current();
        _mint(_to, tokenId);
    }

    function mintBatch(address _to, uint256 _qty) external onlyOwner {
        require(_qty > 0, "Qty cannot be 0");
        for (uint256 i = 0; i < _qty; i++) {
            tokenIdTracker.increment();
            uint256 tokenId = tokenIdTracker.current();
            _mint(_to, tokenId);
        }
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return (
            string(
                abi.encodePacked(
                    baseUrl,
                    "/",
                    Strings.toHexString(uint160(address(this)), 20),
                    "/",
                    Strings.toString(_tokenId)
                )
            )
        );
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        // if (from == address(0)) {
        //     _addTokenToAllTokensEnumeration(tokenId);
        // } else if (from != to) {
        //     _removeTokenFromOwnerEnumeration(from, tokenId);
        // }
        // if (to == address(0)) {
        //     _removeTokenFromAllTokensEnumeration(tokenId);
        // } else if (to != from) {
        //     _addTokenToOwnerEnumeration(to, tokenId);
        // }
    }
}
