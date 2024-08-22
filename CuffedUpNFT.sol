// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";


contract CuffedUpNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable, ERC2981{
    uint256 public _nextTokenId;
    uint256 public constant TOTAL_SUPPLY = 1250;
    address public initialOwnerR;
 uint256 public constant BASE_PRICE_USD = 1250; // $12.50 in USD, considering 1 USD = 100
 struct MusicTrack {
 string name;
 string album;
 }
 mapping(uint256 => MusicTrack) public musicTracks; // Mapping to track music track metadata
 mapping(uint256 => uint256) public royalties; // Mapping to track royalties for each token


    constructor(address initialOwner)
        ERC721("CuffedUpNFT ", "CFD")
        Ownable(initialOwner)
    { initialOwnerR=initialOwner;}

    function _baseURI() internal pure override returns (string memory) {
        return " ";
    }

    function mint(address to) external onlyOwner payable {
        uint256 tokenId = _nextTokenId++;
    require(totalSupply() < TOTAL_SUPPLY, "All tokens have been minted");
    require(tokenId < TOTAL_SUPPLY, "Token ID exceeds maximum supply");
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, "ipfs://QmZEv33hLDpHh3k6YYR6cEbPkaa12U5GLSo9rLaeTJFyai/");
    _setTokenRoyalty( tokenId, initialOwnerR, 100);

    musicTracks[tokenId] = MusicTrack("Cuffed Up", "Aria Harmony");
    royalties[tokenId] = BASE_PRICE_USD * 100; // Set initial royalties to the base price in USD (in cents)
 }
//   function distributeRoyalties(uint256 tokenId, uint256 amount) external onlyOwner {
//     //require(ownerOf(tokenId) == msg.sender, "You are not the owner of this token");
//     require(amount > 0, "Amount should be greater than zero");
//     uint256 balalnce = address(this).balance;
//     address owner = ownerOf(tokenId);
//         payable(owner).transfer(balalnce);
//  // Distribute royalties to token holders
//  // Implement your logic here
//  }




    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    // function customTransferFrom(address from,address to,uint256 tokenId) public payable {
    //     require(msg.value>0.01 ether);
    //     safeTransferFrom(from, to, tokenId);

    // }

    // function safeMint(address to, string memory uri) public onlyOwner {
        
    //     _safeMint(to, tokenId);
    //     _setTokenURI(tokenId, uri);
    // }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage,ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
