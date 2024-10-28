// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

// ERC721 contract with Chainlink VRF functionality for randomized metadata assignment
contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage, VRFConsumerBaseV2Plus {
    uint256 private _nextTokenId;

    // Chainlink VRF configuration - parameters for VRF setup on Avalanche Fuji testnet
    uint256 s_subscriptionId; // Subscription ID for Chainlink VRF
    address vrfCoordinator = 0x5C210eF41CD1a72de73bF76eC39637bB0d3d7BEE; // VRF Coordinator address
    bytes32 s_keyHash = 0xc799bd1e3bd4d1a41cd4968997a4e03dfd2a3c7c04b695881138580163f42887; // Key hash for VRF
    uint32 callbackGasLimit = 100_000; // Gas limit for the VRF callback function
    uint16 requestConfirmations = 3; // Number of confirmations for VRF request
    uint32 numWords =  1; // Number of random words requested

    // Metadata URIs for token attributes
    string constant META_DATA_1 = "ipfs://QmXw7TEAJWKjKifvLE25Z9yjvowWk2NWY3WgnZPUto9XoA";
    string constant META_DATA_2 = "ipfs://QmTFXZBmmnSANGRGhRVoahTTVPJyGaWum8D3YicJQmG97m";
    string constant META_DATA_3 = "ipfs://QmSM5h4WseQWATNhFWeCbqCTAGJCZc11Sa1P5gaXk38ybT";

    // Mapping to store the relationship between request ID and token ID
    mapping(uint256 => uint256) requestIdToTokenId;

    // Constructor - initializes contract with subscription ID and setups VRF coordinator
    // NOTE: Deploy the contract with EVM version Paris for compatibility
    constructor(uint256 subscriptionId) VRFConsumerBaseV2Plus(vrfCoordinator) ERC721("MyToken", "MTK"){
        s_subscriptionId = subscriptionId;
    }

    // Function to mint a new token and request random metadata assignment
    function safeMint() public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        
        // Request random number from Chainlink VRF
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                // Set nativePayment to true to pay for VRF requests with native token instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );

        // Map request ID to token ID for callback reference
        requestIdToTokenId[requestId] = tokenId;
    }

    // Callback function for Chainlink VRF to assign metadata based on randomness
    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        uint256 tokenId = requestIdToTokenId[requestId];
        uint256 randomNumber = randomWords[0];
        
        // Assign metadata based on modulo operation of random number
        if(randomNumber % 3 == 0) {
            _setTokenURI(tokenId, META_DATA_1);
        } else if(randomNumber % 3 == 1) {
            _setTokenURI(tokenId, META_DATA_2);
        } else {
            _setTokenURI(tokenId, META_DATA_3);
        }
    }

    // Overrides for Solidity compatibility with multiple inherited contracts

    // Updates token ownership and authorization
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    // Increases balance of a specified account
    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    // Returns the URI for a token's metadata
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // Checks if the contract supports a specific interface
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}