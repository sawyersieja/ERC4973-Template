// ERC4973Template.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/********************************************************************************************
 * The OpenZeppelin library has not implemented the ERC4973 yet(as of 07/08/25) and it's still under review.
 * We will be creating our own implementation to test things out.
 * We will be borrowing from EIP-4973
 * https://eips.ethereum.org/EIPS/eip-4973
 */

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**************************************************************************************
 * THE "SOULBOUND" TOKEN aka ABT (Account-Bound Token), The ERC-4973:
 *
 * MUST implement the ERC721Metadata interface (name(), symbol(), tokenURI())
 * MUST NOT implement the full ERC721 standard(NO transferFrom, NO approve, and tokens are NON-transferable)
 * SHOULD allow burn() or unequip() pattern for user-controlled revocation
 * SHOULD allow revoke() for issuer revocation
 * SHOULD emit Issued and Revoked events
 *
 * ERC-165 is about interface detection, which we need for ERC721Metadata support
 */

contract ERC4973Template is ERC165, Ownable {
    using Strings for uint256;

    string private _name = "ERC4973Name";
    string private _symbol = "ERC4973Symbol";

    constructor() Ownable(msg.sender) {}

    uint256 private _tokenCounter;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _tokenByOwner;
    mapping(uint256 => string) private _tokenURIs;

    event Issued(address indexed to, uint256 indexed tokenId);
    event Revoked(address indexed from, uint256 indexed tokenId);

    modifier onlyTokenHolder(address user) {
        require(_tokenByOwner[user] != 0, "No token bound to this address");
        _;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenURIs[tokenId];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _owners[tokenId];
    }

    function boundTokenOf(address user) public view returns (uint256) {
        return _tokenByOwner[user];
    }

    function issue(address to, string memory uri) external onlyOwner {
        require(_tokenByOwner[to] == 0, "Address already has token");

        _tokenCounter++;
        uint256 newTokenId = _tokenCounter;

        _owners[newTokenId] = to;
        _tokenByOwner[to] = newTokenId;
        _tokenURIs[newTokenId] = uri;

        emit Issued(to, newTokenId);
    }

    function revoke(address from) external onlyOwner onlyTokenHolder(from) {
        uint256 tokenId = _tokenByOwner[from];
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        delete _tokenByOwner[from];

        emit Revoked(from, tokenId);
    }

    function unequip() external onlyTokenHolder(msg.sender) {
        uint256 tokenId = _tokenByOwner[msg.sender];
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        delete _tokenByOwner[msg.sender];

        emit Revoked(msg.sender, tokenId);
    }

    // EIP-165: supports ERC165 and ERC721Metadata (NOT full ERC721)
    function supportsInterface(
        bytes4 interfaceId
    ) public view override returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == 0x5b5e139f; // ERC721Metadata
    }
}
