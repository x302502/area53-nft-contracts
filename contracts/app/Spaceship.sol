// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./interfaces/INftDataStore.sol";
import "./interfaces/ISpaceship.sol";

contract Spaceship is Ownable, ReentrancyGuard, Pausable, ERC721, ISpaceship {
    using EnumerableSet for EnumerableSet.AddressSet;

    address private constant ZERO_ADDRESS = address(0);
    using Counters for Counters.Counter;

    Counters.Counter public tokenIdTracker;
    string public baseUrl;
    address private nftDataStore;

    EnumerableSet.AddressSet private minters;

    // Modifier checking Minter role
    modifier onlyMinter() {
        require(
            msg.sender != ZERO_ADDRESS && minters.contains(msg.sender),
            "Spaceship: account not role minter"
        );
        _;
    }

    constructor(string memory _baseUrl, address _nftDataStore)
        ERC721("Area53 Spaceship", "SPACESHIP")
    {
        baseUrl = _baseUrl;
        nftDataStore = _nftDataStore;
    }

    function setBaseUrl(string memory _baseUrl) public onlyOwner {
        baseUrl = _baseUrl;
    }

    function setNftDataStore(address _nftDataStore) public onlyOwner {
        require(
            _nftDataStore != ZERO_ADDRESS,
            "Spaceship: Attribute address invalid"
        );
        nftDataStore = _nftDataStore;
    }

    function updateMinters(address[] memory _minters, bool _isAdd)
        external
        nonReentrant
        onlyOwner
    {
        if (_isAdd) {
            for (uint256 i = 0; i < _minters.length; i++) {
                if (!minters.contains(_minters[i])) {
                    minters.add(_minters[i]);
                }
            }
        } else {
            for (uint256 i = 0; i < _minters.length; i++) {
                if (minters.contains(_minters[i])) {
                    minters.remove(_minters[i]);
                }
            }
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address _to) external whenNotPaused onlyMinter {
        tokenIdTracker.increment();
        uint256 tokenId = tokenIdTracker.current();
        _mint(_to, tokenId);
    }

    function mintBatch(address _to, uint256 _qty)
        external
        whenNotPaused
        onlyMinter
    {
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

    function getAttributeValueOfTokenId(
        bytes32 _attributeCode,
        uint256 _tokenId
    ) external view override returns (uint256) {
        return
            INftDataStore(nftDataStore).getAttributeValueOfTokenId(
                _attributeCode,
                _tokenId
            );
    }
}
