# 🔐 Blockchain Escrow Smart Contract

A decentralized, trustless escrow system implemented in Solidity. This smart contract facilitates secure transactions between buyers and sellers, ensuring that funds are only released upon successful delivery or resolved arbitration.

## 🚀 Features

- **Trustless Escrow**: Funds are held securely on-chain until fulfillment.
- **Dispute Resolution**: Third-party arbitrator can resolve conflicts.
- **Time-bound Transactions**: Deadlines ensure timely operations and allow auto-cancellation.
- **Reentrancy Protection**: Built-in safeguards using OpenZeppelin's `ReentrancyGuard`.

## 🧱 Smart Contract Architecture

### Roles
- **Buyer**: Creates an escrow order and funds it.
- **Seller**: Fulfills the order and marks it as delivered.
- **Arbitrator**: Resolves disputes in case of disagreement.

### Order Lifecycle
1. **Create Order** – Buyer creates and funds the order.
2. **Mark Delivered** – Seller confirms the delivery.
3. **Approve** – Buyer approves and releases funds.
4. **Dispute** – Buyer raises a dispute if dissatisfied.
5. **Resolve** – Arbitrator resolves the dispute.
6. **Timeout Cancel** – Buyer can cancel if seller doesn't deliver in time.

## 📄 Contract Overview

- `createOrder(address seller, address arbitrator)`  
  Creates and funds a new escrow order.

- `markDelivered(uint orderId)`  
  Seller marks order as fulfilled.

- `approveOrder(uint orderId)`  
  Buyer releases funds to seller.

- `raiseDispute(uint orderId)`  
  Buyer raises a dispute.

- `resolveDispute(uint orderId, bool refundBuyer)`  
  Arbitrator resolves the dispute in favor of buyer or seller.

- `cancelIfTimeout(uint orderId)`  
  Buyer cancels if seller does not act before deadline.

## 🧪 Installation & Deployment

### Requirements
- Node.js
- Hardhat
- MetaMask / Ethereum wallet
- Remix IDE

📦 Technologies Used
Solidity (v0.8.20)

OpenZeppelin Contracts

Hardhat

Ethers.js

Ethereum (Testnet/Mainnet)

📌 Security
Uses ReentrancyGuard to prevent reentrancy attacks.

All state transitions and fund movements are strictly validated.

Arbitrator mechanism prevents buyer/seller deadlock.

📜 License
MIT License. See LICENSE file for details.
