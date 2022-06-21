// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ISpaceship is IERC721 {
    function getAttributeValueOfTokenId(
        string memory _attributeCode,
        uint256 _tokenId
    ) external view returns (uint256);
}
