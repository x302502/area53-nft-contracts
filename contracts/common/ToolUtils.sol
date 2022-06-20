// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ToolUtils is Ownable, ReentrancyGuard {
    constructor() {}

    function batchTranferErc721(
        address _nftAddress,
        address _receipt,
        uint256[] memory _tokenIds
    ) external nonReentrant {
        IERC721 nftCt = IERC721(_nftAddress);
        for (uint256 index = 0; index < _tokenIds.length; index++) {
            nftCt.safeTransferFrom(
                address(msg.sender),
                address(_receipt),
                _tokenIds[index]
            );
        }
    }
}
