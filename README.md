# ERC4973 Soulbound Token Template

This repository contains a minimal implementation of the ERC-4973 "Account-Bound Token" (ABT) standard using Foundry. ERC-4973 tokens are non-transferable NFTs (aka "soulbound tokens") intended for identity, membership, or access control purposes. This contract is deployed to the Sepolia testnet and uses GitHub-hosted metadata for free, reliable `tokenURI` support.

This contract (`ERC4973Template.sol`) implements `name()`, `symbol()`, and `tokenURI()` from the ERC-721 Metadata subset. It does not include `transferFrom`, `approve`, or `setApprovalForAll`, ensuring that tokens are non-transferable and bound to a single account. The owner of the contract can issue tokens with `issue(address, string)`, revoke them with `revoke(address)`, and token holders can remove their own token with `unequip()`.

The contract also includes `boundTokenOf(address)` to check which token is bound to a given address, and `ownerOf(tokenId)` for standard lookup compatibility. `supportsInterface(bytes4)` is implemented to support ERC165 and ERC721Metadata detection, even though this is not a full ERC721.

---

## Deployment (Sepolia)

This contract is deployed using Foundry with no .env or key storage. We use the `cast wallet` system with a secure `defaultKey` account setup. Deploy with:

```bash
forge script script/ERC4973Template.s.sol:DeployERC4973Template \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com \
  --account defaultKey \
  --sender <your_wallet_address> \
  --broadcast -vvvv
```

---

## Minting / Issuing a Token

To issue a soulbound token to an address:

```bash
cast send <contract_address> \
  "issue(address,string)" \
  0xRecipientAddress \
  "https://raw.githubusercontent.com/<username>/<repo>/main/metadata.json" \
  --account defaultKey \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com
```

This assigns token ID 1, 2, 3... and binds it to the address. Tokens are non-transferable and only one can be issued per address.

---

## Sample Metadata (metadata.json)

This metadata is used as the `tokenURI` and can be hosted publicly via GitHub:

```json
{
  "name": "ERC-4973 Template Token",
  "description": "A non-transferable, account-bound token for identity or access control testing.",
  "image": "https://via.placeholder.com/512",
  "attributes": [
    {
      "trait_type": "Soulbound",
      "value": "True"
    },
    {
      "trait_type": "Type",
      "value": "Template"
    }
  ]
}
```

Push it to your GitHub repo and use the raw content URL like:

```
https://raw.githubusercontent.com/<your-username>/<your-repo>/main/metadata.json
```

---

## Token Verification

To verify whether an address owns a token:

```bash
cast call <contract_address> "boundTokenOf(address)" 0xYourAddress \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com
```

If the result is a non-zero token ID (like `0x1`), the token is bound to the address.

To check the `tokenURI` for a specific token ID:

```bash
cast call <contract_address> "tokenURI(uint256)" 1 \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com
```

This will return an ABI-encoded string. To decode it:

```bash
cast abi-decode '(string)' 0x<hex_output_here>
```

The decoded result will be your metadata URI.

---

## Revoke / Unequip Tokens

To self-revoke (burn) a token as the token holder:

```bash
cast send <contract_address> "unequip()" \
  --account defaultKey \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com
```

To revoke a token from any address as the contract owner:

```bash
cast send <contract_address> "revoke(address)" 0xVictimAddress \
  --account defaultKey \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com
```

---

## Project Layout

```
.
├── src/
│   └── ERC4973Template.sol              # Soulbound token contract
├── script/
│   └── ERC4973Template.s.sol           # Deployment script
├── metadata.json                       # Sample metadata file
├── out/                                # Build artifacts
├── foundry.toml                        # Foundry config
└── README.md
```

---

## Notes

* ERC-4973 is not yet supported by MetaMask, OpenSea, or Etherscan token tabs.
* Token ownership must be verified via `cast call` or custom UI.
* This template is optimized for learning, testing, and gated-access use cases.
* No transfer or resale support exists — this is intentional.
* GitHub raw URLs work perfectly for test purposes. You can switch to IPFS later if needed.
* No `.env` file is used. Keys are securely managed with `cast wallet` + `--account defaultKey`.

---

## License

MIT
