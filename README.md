# Healthcare Practitioner Credential NFT Contract

##  Overview
This project is a simple Solidity smart contract that issues **NFT credentials** to healthcare practitioners.  
It is designed as a **one-day practice project** for learning how to mint tokens, manage access control, handle metadata, and verify ownership on-chain.

Practitioners receive NFTs that represent their professional licenses. These NFTs can be verified by hospitals, insurers, or patients, and revoked if the license expires or is suspended.

---

##  Features
- **Admin-controlled minting**: Only the healthcare authority (admin wallet) can mint NFTs.
- **Practitioner credentials**: NFTs include metadata such as:
  - Practitioner ID
  - Specialization
  - License expiry date
- **Revocation**: Admin can burn practitioner NFTs if credentials are no longer valid.
- **Verification**: Anyone can check if a practitioner holds a valid NFT license.
- **(Optional)** Renewal: Expired NFTs can be re-minted by admin.
- **(Optional)** Soulbound NFTs: Non-transferable licenses.

---

## 🛠 Tech Stack
- **Smart Contracts**: Solidity `^0.8.x`
- **Framework**: Hardhat
- **Token Standard**: ERC-721 (or ERC-1155 for multiple credentials)
- **Storage**: IPFS/Pinata (for metadata JSON files) 

---

##  Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/prince-konwea/mediVexContract_
cd mediVexContract_
