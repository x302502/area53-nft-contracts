// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "./interfaces/ISpaceship.sol";

contract Spaceship is
    Ownable,
    ReentrancyGuard,
    Pausable,
    ERC721Enumerable,
    ISpaceship
{
    using Counters for Counters.Counter;
    address private constant ZERO_ADDRESS = address(0);

    Counters.Counter public tokenIdTracker;
    string public baseUrl;

    mapping(address => bool) public minters;

    event UpdateMinters(address[] minters, bool isAdd);
    event Mint(uint256 indexed tokenId, address indexed to);
    event MintBatch(uint256[] tokenIds, address indexed to);

    // Modifier checking Minter role

    modifier onlyMinter() {
        require(
            msg.sender != ZERO_ADDRESS && minters[msg.sender],
            "Spaceship: account not role minter"
        );
        _;
    }

    constructor(string memory _baseUrl) ERC721("Spaceship", "Spaceship") {
        baseUrl = _baseUrl;
        minters[msg.sender] = true;
    }

    function setBaseUrl(string memory _baseUrl) public onlyOwner {
        baseUrl = _baseUrl;
    }

    function updateMinters(address[] memory _minters, bool _isAdd)
        external
        nonReentrant
        onlyOwner
    {
        for (uint256 i = 0; i < _minters.length; i++) {
            minters[_minters[i]] = _isAdd;
        }
        emit UpdateMinters(_minters, _isAdd);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address _to)
        external
        override
        whenNotPaused
        onlyMinter
        returns (uint256)
    {
        tokenIdTracker.increment();
        uint256 tokenId = tokenIdTracker.current();
        _mint(_to, tokenId);
        emit Mint(tokenId, _to);
        return tokenId;
    }

    function mintBatch(address _to, uint256 _qty)
        external
        override
        whenNotPaused
        onlyMinter
        returns (uint256[] memory tokenIds)
    {
        require(_qty > 0, "Qty cannot be 0");
        tokenIds = new uint256[](_qty);
        for (uint256 i = 0; i < _qty; i++) {
            tokenIdTracker.increment();
            uint256 tokenId = tokenIdTracker.current();
            _mint(_to, tokenId);
            tokenIds[i] = tokenId;
        }
        emit MintBatch(tokenIds, _to);
        return tokenIds;
    }

    function tokenIdsOfOwner(address _owner)
        external
        view
        override
        returns (uint256[] memory tokenIds)
    {
        uint256 balance = balanceOf(_owner);
        tokenIds = new uint256[](balance);
        for (uint256 i = 0; i < balance; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
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
}
