# AI NFT Valuation Platform

A decentralized NFT valuation and ownership tracking system built on Stacks blockchain using Clarity smart contracts.

## Project Overview

This project implements a platform for valuing NFTs using AI-driven price suggestions, tracking ownership, and maintaining price history. The system consists of two main smart contracts:

1. **NFT Valuation Contract**: Handles the pricing, valuation history, and AI price updates for NFTs.
2. **NFT Ownership Contract**: Manages NFT ownership records, transfers, and portfolio valuation.

## Features

### NFT Valuation Contract

- **Set and track NFT prices**: Set prices for NFTs with proper authorization
- **Price history tracking**: Keep a history of up to 5 previous valuations for each NFT
- **Average price calculation**: Calculate average prices based on historical data
- **AI-driven price updates**: Update NFT prices based on AI valuation models
- **Enhanced security**: Authorization checks prevent unauthorized price modifications

### NFT Ownership Contract

- **NFT registration**: Register new NFTs with metadata
- **Ownership tracking**: Keep track of who owns which NFTs
- **NFT transfers**: Securely transfer NFTs between owners
- **Portfolio valuation**: Calculate the total value of all NFTs owned by an address
- **Integration with valuation contract**: Automatically set initial prices for newly registered NFTs

## Security Features

- Owner-based authorization for sensitive operations
- Input validation to prevent invalid data
- Proper error handling with specific error codes
- Protection against unauthorized transfers
- History tracking for audit purposes

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- [Stacks CLI](https://docs.stacks.co/write-smart-contracts/getting-started) (optional)

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `clarinet check` to verify contracts

### Testing

```bash
clarinet test
```

## Contract Interactions

### Example: Register and Value an NFT

```clarity
;; Register a new NFT
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-ownership register-nft u1 "CryptoPunk #1234")

;; Get the current price
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-valuation get-price u1)

;; Update price with AI valuation
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-valuation update-ai-price u1 u500)

;; Get full valuation history
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-valuation get-valuation-data u1)
```

### Example: Transfer and Portfolio Valuation

```clarity
;; Transfer an NFT to another address
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-ownership transfer-nft u1 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; Get NFT owner
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-ownership get-nft-owner u1)

;; Get all NFTs owned by an address
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-ownership get-owned-nfts 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; Calculate portfolio value
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-ownership get-portfolio-value 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
```

## Future Enhancements

- Implement SIP-009 NFT standard compliance
- Add market-based valuation mechanisms
- Create a DAO for decentralized valuation decisions
- Implement royalty distribution for creators
- Add on-chain analytics for market trends

## License

This project is licensed under the MIT License.
