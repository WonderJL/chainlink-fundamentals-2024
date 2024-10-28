// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on the Sepolia test network

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Interface for interacting with the Token contract
interface TokenInterface {
    function mint(address account, uint256 amount) external;
}

// TokenShop contract to buy tokens using ETH at a fixed price
contract TokenShop {
    
    AggregatorV3Interface internal priceFeed; // Chainlink price feed interface for ETH/USD price
    TokenInterface public minter; // Token contract interface to mint new tokens
    uint256 public tokenPrice = 200; // Price of 1 token in USD cents (2 decimal places)
    address public owner; // Owner of the TokenShop contract
    
    // Constructor initializes the token contract and ETH/USD price feed
    constructor(address tokenAddress) {
        minter = TokenInterface(tokenAddress);
        
        /**
        * Network: Sepolia
        * Aggregator: ETH/USD
        * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        * Refs: https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#sepolia-testnet
        */
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender; // Sets the contract deployer as the owner
    }

    /**
     * @notice Fetches the latest ETH/USD price from Chainlink
     * @return price The current ETH/USD price with 8 decimal places
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    /**
     * @notice Calculates the amount of tokens equivalent to the provided ETH amount
     * @param amountETH Amount of ETH sent by the user
     * @return amountToken Amount of tokens calculated based on the ETH/USD price and token price
     */
    function tokenAmount(uint256 amountETH) public view returns (uint256) {
        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer()); // ETH/USD price with 8 decimal places
        uint256 amountUSD = amountETH * ethUsd / 10**18; // Converts ETH amount to USD, adjusting for 18 ETH decimals
        uint256 amountToken = amountUSD / tokenPrice / 10**(8/2);  // Adjusts for token price with 2 decimal places and ETH/USD decimals
        return amountToken;
    } 

    /**
     * @notice Fallback function that mints tokens equivalent to the ETH received
     */
    receive() external payable {
        uint256 amountToken = tokenAmount(msg.value); // Calculate tokens for the sent ETH
        minter.mint(msg.sender, amountToken); // Mint tokens to the sender's address
    }

    // Modifier to restrict certain functions to the contract owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _; // Placeholder to execute the rest of the function's code if the require check passes
    }

    /**
     * @notice Allows the owner to withdraw the ETH balance of the contract
     */
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance); // Transfer contract's ETH balance to the owner
    }    
}