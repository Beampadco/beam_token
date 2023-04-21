// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BullionTribeClub is ERC721, Ownable {
  using SafeMath for uint256;

  uint256 public MAX_TRIBES;

  string public nftBaseURI;

  uint public totalSupply;

  constructor(uint256 maxNftSupply) ERC721("Bullion Tribe", "TRIBE") {
    MAX_TRIBES = maxNftSupply;
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    _setBaseURI(baseURI);
  }

  function setMaxTribes(uint256 maxNftSupply) public onlyOwner {
    require(
      totalSupply <= MAX_TRIBES,
      "MAX_TRIBES should be greater than TotalSupply"
    );
    MAX_TRIBES = maxNftSupply;
  }

  function _setBaseURI(string memory baseURI) internal virtual {
    nftBaseURI = baseURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return nftBaseURI;
  }

  /**
   * Mints Bullion Tribes
   */
  function mintTribe(uint256 numberOfTokens) public payable {
    require(
      totalSupply.add(numberOfTokens) <= MAX_TRIBES,
      "Mint would exceed max supply of Tribes"
    );

    for (uint i = 1; i <= numberOfTokens; i++) {
      _safeMint(msg.sender, totalSupply.add(i));
    }
    totalSupply += numberOfTokens;
  }
}
