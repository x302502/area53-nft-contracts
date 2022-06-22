// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./interfaces/INftDataStore.sol";

contract NftDataStore is Ownable, ReentrancyGuard, INftDataStore {
    address private constant ZERO_ADDRESS = address(0);
    using EnumerableSet for EnumerableSet.Bytes32Set;

    string public name;
    uint8 public version;

    EnumerableSet.Bytes32Set private attributeCodes;

    mapping(address => bool) public admins;

    event UpdateAdmins(address[] indexed admins, bool isAdd);

    event UpdateAttributeCodes(string[] attributes, bool isAdd);

    // Modifier checking Admin role
    modifier onlyAdmin() {
        require(
            msg.sender != ZERO_ADDRESS && admins[msg.sender],
            "NftDataStore: account not role admin"
        );
        _;
    }
    // attributeCode => tokenId => attribute value
    mapping(bytes32 => mapping(uint256 => uint256)) public mapAttribute;

    constructor(string memory _name, uint8 _version) {
        name = _name;
        version = _version;
        admins[msg.sender] = true;
    }

    function updateAdmins(address[] memory _admins, bool _isAdd)
        external
        nonReentrant
        onlyOwner
    {
        for (uint256 i = 0; i < _admins.length; i++) {
            admins[_admins[i]] = _isAdd;
        }
        emit UpdateAdmins(_admins, _isAdd);
    }

    function updateAttributeCodes(string[] calldata _attributes, bool _isAdd)
        external
        nonReentrant
        onlyAdmin
    {
        for (uint256 i = 0; i < _attributes.length; i++) {
            bytes32 attributeCode = keccak256(abi.encodePacked(_attributes[i]));
            if (_isAdd) {
                attributeCodes.add(attributeCode);
            } else {
                attributeCodes.remove(attributeCode);
            }
        }
        emit UpdateAttributeCodes(_attributes, _isAdd);
    }

    function updateDataByAttribute(
        string memory _attributeCode,
        uint256[] memory _tokenIds,
        uint256[] memory _values
    ) external nonReentrant onlyAdmin {
        require(
            _tokenIds.length == _values.length,
            "NftDataStore: input data invalid"
        );
        bytes32 attributeCode = keccak256(abi.encodePacked(_attributeCode));
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            mapAttribute[attributeCode][_tokenIds[i]] = _values[i];
        }
    }

    function getAttributeValueOfTokenId(
        string memory _attributeCode,
        uint256 _tokenId
    ) external view virtual override returns (uint256) {
        bytes32 attributeCode = keccak256(abi.encodePacked(_attributeCode));
        return mapAttribute[attributeCode][_tokenId];
    }
}
