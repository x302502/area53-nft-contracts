// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "./interfaces/ISpaceship.sol";
import "./interfaces/ISpaceshipBox.sol";

contract SpaceshipBox is
    Ownable,
    ReentrancyGuard,
    Pausable,
    ERC721Enumerable,
    ISpaceshipBox
{
    using Counters for Counters.Counter;
    address private constant ZERO_ADDRESS = address(0);

    uint256 public constant LV1 = 1;
    uint256 public constant LV2 = 2;
    uint256 public constant LV3 = 3;

    Counters.Counter public tokenIdTracker;
    string public baseUrl;

    address public collectionAddress;
    bool public enableOpenBox = false;

    mapping(uint256 => uint256) public level;
    mapping(address => bool) public minters;

    event UpdateMinters(address[] minters, bool isAdd);
    event Mint(
        uint256 indexed tokenId,
        uint256 indexed level,
        address indexed to
    );
    event MintBatch(
        uint256[] tokenIds,
        uint256 indexed level,
        address indexed to
    );

    event OpenBox(
        address indexed owner,
        uint256 indexed boxId,
        uint256 indexed tokenId,
        uint256 level
    );

    event UpdateEnableOpenBox(bool enable);

    // Modifier checking Minter role

    modifier onlyMinter() {
        require(
            msg.sender != ZERO_ADDRESS && minters[msg.sender],
            "SpaceshipBox: account not role minter"
        );
        _;
    }

    modifier verifyLevel(uint256 _level) {
        require(
            _level == LV1 || _level == LV2 || _level == LV3,
            "SpaceshipBox: Level invalid value"
        );
        _;
    }

    constructor(string memory _baseUrl, address _collectionAddress)
        ERC721("Spaceship Box", "SpaceshipBox")
    {
        baseUrl = _baseUrl;
        collectionAddress = _collectionAddress;
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

    function mint(address _to, uint256 _level)
        external
        override
        whenNotPaused
        onlyMinter
        verifyLevel(_level)
        returns (uint256)
    {
        tokenIdTracker.increment();
        uint256 tokenId = tokenIdTracker.current();
        _mint(_to, tokenId);
        level[tokenId] = _level;
        emit Mint(tokenId, _level, _to);
        return tokenId;
    }

    function mintBatch(
        address _to,
        uint256 _qty,
        uint256 _level
    )
        external
        override
        whenNotPaused
        onlyMinter
        verifyLevel(_level)
        returns (uint256[] memory tokenIds)
    {
        require(_qty > 0, "Qty cannot be 0");
        tokenIds = new uint256[](_qty);
        for (uint256 i = 0; i < _qty; i++) {
            tokenIdTracker.increment();
            uint256 tokenId = tokenIdTracker.current();
            _mint(_to, tokenId);
            level[tokenId] = _level;
            tokenIds[i] = tokenId;
        }
        emit MintBatch(tokenIds, _level, _to);
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

    function _openBox(uint256 _boxId) private {
        require(
            ownerOf(_boxId) == msg.sender,
            "SpaceshipBox:Caller is not owner of this box"
        );
        uint256 tokenId = ISpaceship(collectionAddress).mint(msg.sender);
        emit OpenBox(msg.sender, _boxId, tokenId, level[_boxId]);
        _burn(_boxId);
    }

    function openBox(uint256 _boxId) external override {
        require(enableOpenBox == true, "Open box is disable");
        _openBox(_boxId);
    }

    function openBoxs(uint256[] memory _boxIds) external override {
        require(enableOpenBox == true, "Open box is disable");
        for (uint256 i = 0; i < _boxIds.length; i++) {
            _openBox(_boxIds[i]);
        }
    }

    function updateEnableOpenBox(bool _enable) public onlyOwner {
        enableOpenBox = _enable;
        emit UpdateEnableOpenBox(_enable);
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
