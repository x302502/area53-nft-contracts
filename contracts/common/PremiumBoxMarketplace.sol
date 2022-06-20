// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PremiumBoxMarketplace is IERC721Receiver, Ownable {
    using SafeERC20 for IERC20;
    IERC721Enumerable private box;
    IERC20 private token;

    struct ListDetail {
        address payable author;
        uint256 price;
        uint256 tokenId;
    }

    event ListBox(address indexed _from, uint256 _tokenId, uint256 _price);
    event UnlistBox(address indexed _from, uint256 _tokenId);
    event BuyBox(address indexed _from, uint256 _tokenId, uint256 _price);
    event UpdateListingBoxPrice(uint256 _tokenId, uint256 _price);
    event SetToken(IERC20 _token);
    event SetTax(uint256 _tax);

    event SetBox(IERC721Enumerable _box);

    uint256 private tax = 10; // percentage
    mapping(uint256 => ListDetail) public listDetail;

    constructor(IERC20 _token, IERC721Enumerable _box) {
        box = _box;
        token = _token;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }

    function setTax(uint256 _tax) public onlyOwner {
        tax = _tax;
        emit SetTax(_tax);
    }

    function setToken(IERC20 _token) public onlyOwner {
        token = _token;
        emit SetToken(_token);
    }

    function setNft(IERC721Enumerable _box) public onlyOwner {
        box = _box;
        emit SetBox(_box);
    }

    function getListedBox() public view returns (ListDetail[] memory) {
        uint256 balance = box.balanceOf(address(this));
        ListDetail[] memory myBox = new ListDetail[](balance);

        for (uint256 i = 0; i < balance; i++) {
            myBox[i] = listDetail[box.tokenOfOwnerByIndex(address(this), i)];
        }
        return myBox;
    }

    function listBox(uint256 _tokenId, uint256 _price) public {
        require(
            box.ownerOf(_tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
        require(
            box.getApproved(_tokenId) == address(this),
            "Marketplace is not approved to transfer this NFT"
        );

        listDetail[_tokenId] = ListDetail(
            payable(msg.sender),
            _price,
            _tokenId
        );

        box.safeTransferFrom(msg.sender, address(this), _tokenId);
        emit ListBox(msg.sender, _tokenId, _price);
    }

    function updateListingBoxPrice(uint256 _tokenId, uint256 _price) public {
        require(
            box.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].author == msg.sender,
            "Only owner can update price of this NFT"
        );

        listDetail[_tokenId].price = _price;
        emit UpdateListingBoxPrice(_tokenId, _price);
    }

    function unlistNft(uint256 _tokenId) public {
        require(
            box.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].author == msg.sender,
            "Only owner can unlist this NFT"
        );

        box.safeTransferFrom(address(this), msg.sender, _tokenId);
        emit UnlistBox(msg.sender, _tokenId);
    }

    function buyBox(uint256 _tokenId, uint256 _price) public {
        require(
            token.balanceOf(msg.sender) >= _price,
            "Insufficient account balance"
        );
        require(
            box.ownerOf(_tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            listDetail[_tokenId].price <= _price,
            "Minimum price has not been reached"
        );

        SafeERC20.safeTransferFrom(token, msg.sender, address(this), _price);
        token.transfer(
            listDetail[_tokenId].author,
            (_price * (100 - tax)) / 100
        );

        box.safeTransferFrom(address(this), msg.sender, _tokenId);
        emit BuyBox(msg.sender, _tokenId, _price);
    }

    //

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawErc20() public onlyOwner {
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function withdrawToken(uint256 amount) public onlyOwner {
        require(
            token.balanceOf(address(this)) >= amount,
            "Insufficient account balance"
        );
        token.transfer(msg.sender, amount);
    }
}
