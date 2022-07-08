// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

interface ISpaceshipBox is IERC721Enumerable {
    function mint(address _to, uint256 _level) external returns (uint256);

    function mintBatch(
        address _to,
        uint256 _qty,
        uint256 _level
    ) external returns (uint256[] memory tokenIds);

    function tokenIdsOfOwner(address _owner)
        external
        view
        returns (uint256[] memory tokenIds);

    function openBox(uint256 _boxId) external;

    function openBoxs(uint256[] memory _boxIds) external;
}
