// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INftDataStore {
    function getAttributeValueOfTokenId(
        bytes32 _attributeCode,
        uint256 _tokenId
    ) external view returns (uint256);
}
