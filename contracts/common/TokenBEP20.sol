// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./BEP20.sol";

contract TokenBEP20 is BEP20 {
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply
    )
        BEP20(
            name,
            symbol,
            decimals,
            uint256(totalSupply) * uint256(10)**decimals
        )
    {}
}
