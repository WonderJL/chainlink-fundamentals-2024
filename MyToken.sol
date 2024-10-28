// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Import ERC20 and AccessControl contracts from OpenZeppelin library
import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.6.0/access/AccessControl.sol";

// Define the Token contract, inheriting from both ERC20 and AccessControl
contract Token is ERC20, AccessControl {
    // Define a role identifier for minter role using keccak256 hash function
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Constructor to initialize the token with a name and symbol and assign roles
    constructor() ERC20("Chainlink Bootcamp 2024 Token By J", "CLBoot24J") {
        // Grant the deployer the default admin role, which allows managing all roles
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // Grant the deployer the minter role, enabling them to mint new tokens
        _grantRole(MINTER_ROLE, msg.sender);
    }

    // Mint function allows addresses with the MINTER_ROLE to create new tokens
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount); // Call OpenZeppelin’s internal _mint function
    }

    // Override the decimals function to set the token’s decimal places to 2
    function decimals() public pure override returns (uint8) {
        return 2;
    }
}