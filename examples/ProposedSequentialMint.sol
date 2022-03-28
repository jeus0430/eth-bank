// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC721Pausable.sol";

contract CryptoAthletes is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {

    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    uint256 private nftPrice;
    uint256 private nftMaxSupply;
    uint256 private nftMaxMint;

    address private constant ownerAddress = 0x00000; // Wallet Address of Owner
    address public constant developerAddress = 0x00000; // Wallet Address of the Cory

    string private baseTokenURI;

    bool private lockURI = false;

    event CreateCryptoAthletes(address to, uint256 indexed id);

    // ---------- PRICE HISTORY CODE -------------------
    struct priceHistoryItem {
        uint256 index;
        uint256 price;
    }
    priceHistoryItem[] priceHistory;

    // Update price and save in price history
    function setPrice(uint256 price) public onlyOwner {
        nftPrice = price;
        uint256 currentIndex = _totalSupply();
        priceHistory.push([currentIndex, price]);
    }

    // This function returns the Total (cumulative) and Average cost of ALL NFT mints.
    function getTotalAndAverageMintCost() public returns (uint256 total, uint256 averageCost) {
        uint256 total = 0;
        uint256 prevTokenIndex = 0;
        // iterate through each butcket and
        for (uint256 i = 0; i < priceHistory.length; i++) {
            uint256 numberOfItemsInBucket = priceHistory[i].index - prevIndex;
            uint256 totalCostInBucket = numberOfItemsInBucket * priceHistory[i].price;
            total = total + totalCostInBucket;
            prevTokenIndex = priceHistory[i].index;
        }
        //add latest items minted after the last price history record
        uint256 numberOfItemsInLastBucket = _totalSupply() - prevTokenIndex;
        uint256 totalCostInLastBucket = numberOfItemsInBucket * priceHistory[priceHistory.length].price;
        total = total + totalCostInLastBucket;
        //calculate average cost
        uint256 averageCost = totalCost / _totalSupply();
        return (total, averageCost);
    }

    modifier saleIsOpen {
        require(_totalSupply() <= nftMaxSupply, "SALES: Sale end");

        if (_msgSender() != owner()) {
            require(!paused(), "PAUSABLE: Paused");
        }
        _;
    }

    constructor (string memory baseURI, uint256 maxSupply, uint256 maxMint, uint256 price) ERC721("CryptoAthletes", "CATH") {
        setBaseURI(baseURI);
        pause(true);

        nftPrice = price;
        nftMaxSupply = maxSupply;
        nftMaxMint = maxMint;
    }

    uint256 private nftPrice;
    uint256 private nftMaxSupply;
    uint256 private nftMaxMint;

    function mint(address payable _to, uint256[] memory _count) public payable saleIsOpen {
        uint256 total = _totalSupply();

        require(total + _count <= nftMaxSupply, "MINT: Current count exceeds maximum element count.");
        require(total <= nftMaxSupply, "MINT: Please go to the Opensea to buy Crypto Athletes.");
        require(_count <= nftMaxMint, "MINT: Current count exceeds maximum mint count.");
        require(msg.value >= price(_count), "MINT: Current value is below the sales price of Crypto Athletes");

        for (uint256 i = 0; i < _count; i++) {
            _mintAnElement(_to);
        }
    }

    function _mintAnElement(address payable _to) private {
        uint id = _totalSupply();
        _tokenIdTracker.increment();
        _safeMint(_to, _id);

        emit MintEvent(_to, _id);
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
      require(!lockURI, "CONTRACT: Changing baseuri is locked by owner!");

      baseTokenURI = baseURI;
    }

    function lockBaseURI(bool _lock) public onlyOwner {
      lockURI = _lock;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function price(uint256 _count) public pure returns (uint256) {
        return nftPrice.mul(_count);
    }

    function setPrice(uint256 price) public onlyOwner {
      nftPrice = price;
    }

    function _totalSupply() internal view returns (uint) {
        return _tokenIdTracker.current();
    }

    function maxMint() public view returns (uint256) {
        return nftMaxMint;
    }

    function maxSales() public view returns (uint256) {
        return nftMaxSupply;
    }

    function raised() public view returns (uint256) {
        return address(this).balance;
    }

    function getTokenIdsOfWallet(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function pause(bool value) public onlyOwner {
        if (value == true) {
            _pause();

            return;
        }

        _unpause();
    }

    function withdrawAll() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "WITHDRAW: No balance in contract");

        _widthdraw(developerAddress, balance.mul(50).div(100));
        _widthdraw(ownerAddress, address(this).balance);
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "WITHDRAW: Transfer failed.");
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
