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
    using EnumerableSet for EnumerableSet.AddressSet;

    string public name;
    uint8 public version;

    EnumerableSet.Bytes32Set private attributeCodes;

    EnumerableSet.AddressSet private admins;

    // Modifier checking Admin role
    modifier onlyAdmin() {
        require(
            admins.contains(msg.sender),
            "FamLegendAttribute: account not role admin"
        );
        _;
    }
    // attributeCode => tokenId => attribute value
    mapping(bytes32 => mapping(uint256 => uint256)) public mapAttribute;

    function random() internal view returns (uint256) {
        uint256 randomnumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        );
        return randomnumber;
    }

    constructor(string memory _name, uint8 _version) {
        name = _name;
        version = _version;
        transferOwnership(msg.sender);
        admins.add(msg.sender);
    }

    function addAdmins(address[] memory _admins)
        external
        nonReentrant
        onlyOwner
    {
        for (uint256 i = 0; i < _admins.length; i++) {
            if (!admins.contains(_admins[i])) {
                admins.add(_admins[i]);
            }
        }
    }

    function removeAdmins(address[] memory _admins)
        external
        nonReentrant
        onlyOwner
    {
        for (uint256 i = 0; i < _admins.length; i++) {
            if (admins.contains(_admins[i])) {
                admins.remove(_admins[i]);
            }
        }
    }

    function addAttributeCodes(string[] calldata _attributes)
        external
        nonReentrant
        onlyAdmin
    {
        for (uint256 i = 0; i < _attributes.length; i++) {
            bytes32 attributeCode = keccak256(abi.encodePacked(_attributes[i]));
            if (!attributeCodes.contains(attributeCode)) {
                attributeCodes.add(attributeCode);
            }
        }
    }

    function removeAttributeCodes(string[] calldata _attributes)
        external
        nonReentrant
        onlyAdmin
    {
        for (uint256 i = 0; i < _attributes.length; i++) {
            bytes32 attributeCode = keccak256(abi.encodePacked(_attributes[i]));
            if (attributeCodes.contains(attributeCode)) {
                attributeCodes.remove(attributeCode);
            }
        }
    }

    function updateDataByAttribute(
        string memory _attributeCode,
        uint256[] memory _tokenIds,
        uint256[] memory _values
    ) external nonReentrant onlyAdmin {
        require(
            _tokenIds.length == _values.length,
            "FamLegendAttribute: input data invalid"
        );
        bytes32 attributeCode = keccak256(abi.encodePacked(_attributeCode));
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            mapAttribute[attributeCode][_tokenIds[i]] = _values[i];
        }
    }

    function getAttributeValueOfTokenId(
        bytes32 _attributeCode,
        uint256 _tokenId
    ) external view virtual override returns (uint256) {
        return mapAttribute[_attributeCode][_tokenId];
    }
}
