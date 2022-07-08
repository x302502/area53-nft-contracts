// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./interfaces/ISpaceshipBox.sol";

contract PoolMintBox is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    address public boxAddress;
    address public tokenDeposit;
    uint256 public totalAllocation;
    uint256 public totalMinted;

    // level => priceBox
    mapping(uint256 => uint256) public priceBoxs;

    constructor(
        address _boxAddress,
        address _tokenDeposit,
        uint256[] memory _priceBoxs,
        uint256 _totalAllocation
    ) {
        require(_boxAddress != address(0), "PoolMintBox: boxAddress invalid");
        require(
            _tokenDeposit != address(0),
            "PoolMintBox: tokenDeposit invalid"
        );
        for (uint256 i = 0; i < _priceBoxs.length; i++) {
            require(_priceBoxs[i] > 0, "PoolMintBox: PriceBox invalid");
            priceBoxs[i + 1] = _priceBoxs[i];
        }
        boxAddress = _boxAddress;
        tokenDeposit = _tokenDeposit;
        totalAllocation = _totalAllocation;
        totalMinted = 0;
    }

    function mint(uint256 _qty, uint256 _level) external {
        require(priceBoxs[_level] > 0, "PoolMintBox: PriceBox not setup");
        require(_qty > 0, "PoolMintBox: Qty invalid");
        require(
            totalMinted + _qty < totalAllocation,
            "PoolMintBox: Full size minted"
        );
        IERC20(tokenDeposit).safeTransferFrom(
            address(msg.sender),
            address(this),
            priceBoxs[_level] * _qty
        );
        ISpaceshipBox(boxAddress).mintBatch(msg.sender, _qty, _level);
        totalMinted += _qty;
    }
}
