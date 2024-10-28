// SPDX-License-Identifier: MIT  
pragma solidity 0.8.19;

// Struct to hold log data from the blockchain
struct Log {  
    uint256 index; // Index of the log in the block  
    uint256 timestamp; // Timestamp of the block containing the log  
    bytes32 txHash; // Hash of the transaction containing the log  
    uint256 blockNumber; // Number of the block containing the log  
    bytes32 blockHash; // Hash of the block containing the log  
    address source; // Address of the contract that emitted the log  
    bytes32[] topics; // Indexed topics of the log  
    bytes data; // Data of the log  
}

// Interface defining methods for automated log checking and upkeep
interface ILogAutomation {  
    function checkLog(  
        Log calldata log,  
        bytes memory checkData  
    ) external returns (bool upkeepNeeded, bytes memory performData);

    function performUpkeep(bytes calldata performData) external;  
}

// Contract implementing log automation with a counter for logs
contract LogTrigger is ILogAutomation {  
    event CountedBy(address indexed msgSender); // Event for tracking who counted

    uint256 public counted = 0; // Counter for logs processed

    constructor() {} // Constructor

    // Function to check log data and prepare for upkeep if conditions met
    function checkLog(  
        Log calldata log,  
        bytes memory  
    ) external pure returns (bool upkeepNeeded, bytes memory performData) {  
        upkeepNeeded = true;  // Upkeep needed, e.g., log received
        address logSender = bytes32ToAddress(log.topics[1]);  // Extract sender address from log topics
        performData = abi.encode(logSender);  // Encode sender address as perform data
    }

    // Function to perform the upkeep operation
    function performUpkeep(bytes calldata performData) external override {  
        counted += 1;  // Increment log counter
        address logSender = abi.decode(performData, (address));  // Decode perform data to get sender address
        emit CountedBy(logSender);  // Emit event with sender address
    }

    // Helper function to convert bytes32 to address format
    function bytes32ToAddress(bytes32 _address) public pure returns (address) {  
        return address(uint160(uint256(_address)));  
    }  
}