
# Time-Based Contract with Chainlink Automation

This project includes a simple smart contract `TimeBased.sol`, written in Solidity, that maintains a counter and increments it automatically using Chainlink's Time-Based Automation (Upkeep) feature.

## Overview

The `TimeBased` contract is designed to:
- Maintain a publicly accessible `counter` variable.
- Increment `counter` by 1 every time the `count` function is called.
  
This contract is integrated with Chainlink Automation on the Sepolia testnet to automatically call the `count` function at specified intervals, keeping the `counter` updated without manual intervention.

## Smart Contract Details

### TimeBased.sol

The `TimeBased` contract is a basic smart contract in Solidity:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeBased {  
    uint256 public counter;  

    function count() public {  
        counter += 1;  
    }  
}
```

- **License**: MIT (open-source license).
- **Solidity Version**: 0.8.0 or later, leveraging newer language features and built-in security improvements.
- **Public Variables**: The `counter` variable is publicly accessible, allowing anyone to view its current value.
- **Functionality**: The `count` function increments `counter` by 1 each time it is called.

### Chainlink Automation (Upkeep)

This contract is connected to Chainlink’s Automation (Upkeep) to ensure the `count` function is called at regular intervals. With this integration, `counter` is automatically incremented without requiring manual transactions.

You can find the Chainlink Automation setup for this contract on the Sepolia testnet at the following link:
[Chainlink Automation Upkeep on Sepolia](https://automation.chain.link/sepolia/7422444313292657795426043666251116801700178362719134666200861964733095782156)

## Getting Started

### Prerequisites

Ensure you have the following installed:
- [Node.js and npm](https://nodejs.org/) for handling dependencies.
- [Hardhat](https://hardhat.org/) or [Truffle](https://trufflesuite.com/) as your Solidity development environment.
- [MetaMask](https://metamask.io/) or another Ethereum-compatible wallet.
- Testnet ETH in your wallet to deploy the contract on Sepolia.

### Setup

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Compile the Smart Contract**:
   ```bash
   npx hardhat compile
   ```

4. **Deploy the Smart Contract**:
   Deploy `TimeBased.sol` on Sepolia or your preferred test network by running:
   ```bash
   npx hardhat run scripts/deploy.js --network sepolia
   ```

### Testing

You can interact with the contract locally or on the Sepolia testnet:
```bash
npx hardhat console --network sepolia
> const TimeBased = await ethers.getContractFactory("TimeBased");
> const timeBased = await TimeBased.deploy();
> await timeBased.count(); // Increment the counter
> (await timeBased.counter()).toString(); // Check the counter value
```

### Chainlink Automation

To observe Chainlink Automation in action, visit the Chainlink Automation Upkeep link provided above.