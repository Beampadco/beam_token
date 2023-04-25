// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BullionTribe is ERC721, Ownable {
  using SafeMath for uint256;

  uint256 public MAX_TRIBES = 10000;

  string public nftBaseURI;

  uint public totalSupply;

  mapping(address => bool) minters;

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

  modifier onlyMinter() {
    require(minters[_msgSender()], "BullionTribe: caller is not a minter");
    _;
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    _setBaseURI(baseURI);
  }

  function addMinter(address user) public onlyOwner {
    minters[user] = true;
  }

  function removeMinter(address user) public onlyOwner {
    minters[user] = false;
  }

  function _setBaseURI(string memory baseURI) internal virtual {
    nftBaseURI = baseURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return nftBaseURI;
  }

  /**
   * Mints bulk Bullion Tribes
   */
  function mintBulk(uint256 numberOfTokens, address wallet) public onlyMinter {
    require(
      totalSupply.add(numberOfTokens) <= MAX_TRIBES,
      "BullionTribe: Mint would exceed max supply of Tribes"
    );

    for (uint i = 1; i <= numberOfTokens; i++) {
      _safeMint(wallet, totalSupply.add(i));
    }
    totalSupply += numberOfTokens;
  }

  /**
   * Mints a single Bullion Tribe with a tokne id
   */
  function mint(address wallet) public onlyMinter {
    require(
      totalSupply.add(1) <= MAX_TRIBES,
      "BullionTribe: Mint would exceed max supply of Tribes"
    );

    _safeMint(wallet, totalSupply.add(1));
    totalSupply++;
  }
}
