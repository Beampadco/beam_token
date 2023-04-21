// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BullionTribeClub is ERC721, Ownable {
  using SafeMath for uint256;

  uint256 public tribePrice = 80000000000000000; //0.08 ETH

  uint public maxTribePurchase = 20;

  uint256 public MAX_TRIBES;

  bool public saleIsActive = false;

  uint256 public REVEAL_TIMESTAMP;

  string public nftBaseURI;

  uint public totalSupply;

  constructor(
    uint256 maxNftSupply,
    uint256 saleStart
  ) ERC721("Bullion Tribe", "TRIBE") {
    MAX_TRIBES = maxNftSupply;
    REVEAL_TIMESTAMP = saleStart + (86400 * 9);
  }

  function withdraw() public onlyOwner {
    uint balance = address(this).balance;
    payable(msg.sender).transfer(balance);
  }

  /**
   * Set some Bullion Tribes aside
   */
  function reserveTribes() public onlyOwner {
    uint i;
    for (i = 0; i < 30; i++) {
      _safeMint(msg.sender, totalSupply + i);
      totalSupply++;
    }
  }

  /**
   * DM Gargamel in Discord that you're standing right behind him.
   */
  function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
    REVEAL_TIMESTAMP = revealTimeStamp;
  }

  function setTribePrice(uint256 price) public onlyOwner {
    tribePrice = price;
  }

  function setMaxTribePurchase(uint256 purchase) public onlyOwner {
    maxTribePurchase = purchase;
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    _setBaseURI(baseURI);
  }

  function _setBaseURI(string memory baseURI) internal virtual {
    nftBaseURI = baseURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return nftBaseURI;
  }

  /*
   * Pause sale if active, make active if paused
   */
  function flipSaleState() public onlyOwner {
    saleIsActive = !saleIsActive;
  }

  /**
   * Mints Bullion Tribes
   */
  function mintTribe(uint numberOfTokens) public payable {
    require(saleIsActive, "Sale must be active to mint Tribe");
    require(
      numberOfTokens <= maxTribePurchase,
      "Can only mint 20 tokens at a time"
    );
    require(
      totalSupply.add(numberOfTokens) <= MAX_TRIBES,
      "Purchase would exceed max supply of Tribes"
    );
    require(
      tribePrice.mul(numberOfTokens) <= msg.value,
      "Ether value sent is not correct"
    );

    for (uint i = 0; i < numberOfTokens; i++) {
      uint mintIndex = totalSupply;
      if (totalSupply < MAX_TRIBES) {
        _safeMint(msg.sender, mintIndex);
        totalSupply++;
      }
    }
  }
}
