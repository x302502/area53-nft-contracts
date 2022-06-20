// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IHero.sol";

contract HeroBox is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    string private _url;
    address public token_address;
    bool public enableOpenBox = false;
    uint256 public boxType = 7;
    event OpenBox(address to, uint256 boxType, uint256 tokenid);
    event SetEnableOpenBox(bool enable);
    event SetBoxType(uint256 btype);
    event SetToken(address token);

    constructor(address token) ERC721("Hero Box", "HeroBox") {
        token_address = token;
    }

    function _baseURI()
        internal
        view
        override
        returns (string memory _newBaseURI)
    {
        return _url;
    }

    function mint(address to) public onlyOwner returns (uint256) {
        _tokenIdTracker.increment();
        uint256 token_id = _tokenIdTracker.current();
        _mint(to, token_id);
        return token_id;
    }

    function mint_to(address to, uint256 amount) public onlyOwner {
        for (uint256 i = 0; i < amount; i++) {
            mint(to);
        }
    }

    function listBoxIds(address owner)
        public
        view
        returns (uint256[] memory boxIds)
    {
        uint256 balance = balanceOf(owner);
        uint256[] memory ids = new uint256[](balance);

        for (uint256 i = 0; i < balance; i++) {
            ids[i] = tokenOfOwnerByIndex(owner, i);
        }
        return (ids);
    }

    function setBaseUrl(string memory _newUrl) public onlyOwner {
        _url = _newUrl;
    }

    function openBox(uint256 boxId) public returns (uint256 _tokenid) {
        require(enableOpenBox == true, "Open box is disable");
        require(
            ownerOf(boxId) == _msgSender(),
            "Caller is not owner of this box"
        );
        uint256 tokenid = IHero(token_address).mint(_msgSender(), boxType);
        _burn(boxId);
        emit OpenBox(_msgSender(), boxType, tokenid);
        return tokenid;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return baseURI;
    }

    function setEnableOpenBox(bool enable) public onlyOwner {
        enableOpenBox = enable;
        emit SetEnableOpenBox(enable);
    }

    function setBoxType(uint256 _type) public onlyOwner {
        boxType = _type;
        emit SetBoxType(_type);
    }

    function setToken(address _token) public onlyOwner {
        token_address = _token;
        emit SetToken(_token);
    }
}
