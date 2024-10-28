// SPDX-License-Identifier: MIT  
pragma solidity 0.8.19;

// Importing Chainlink's AutomationCompatibleInterface for using automation functions
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

// Define the main contract which implements Chainlink's automation interface
contract CustomLogic is AutomationCompatibleInterface {

    // Public state variable to store the counter's current value
    uint256 public counter;  
    // Immutable state variable that holds the interval between upkeeps
    uint256 public immutable interval;  
    // State variable to store the last timestamp of the upkeep
    uint256 public lastTimeStamp;

    // Constructor to initialize the interval and set initial timestamp and counter
    constructor(uint256 updateInterval) {  
        interval = updateInterval;  
        lastTimeStamp = block.timestamp;
        counter = 0;  
    }

    // Chainlink automation function to check if upkeep is needed
    function checkUpkeep(  
        bytes calldata /* checkData */  // Unused parameter for potential future data
    )  
        external  
        view  
        override  
        returns (bool upkeepNeeded, bytes memory)  
    {  
        // Set upkeepNeeded to true if the time since last upkeep exceeds the interval
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;  
    }

    // Chainlink automation function to perform the upkeep
    function performUpkeep(bytes calldata) external override {  
        // Only proceed if the time since last upkeep exceeds the interval
        if ((block.timestamp - lastTimeStamp) > interval) {  
            lastTimeStamp = block.timestamp;  // Update the last upkeep timestamp
            counter = counter + 1;  // Increment the counter
        }  
    }  
}
