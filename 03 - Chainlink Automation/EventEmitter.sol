// SPDX-License-Identifier: MIT  
pragma solidity 0.8.19;

// Contract to emit a custom event, useful for tracking specific actions
contract EventEmitter {  
    // Event declaration with an indexed parameter for filtering by sender
    event WantsToCount(address indexed msgSender);

    // Constructor - no initialization needed for this contract
    constructor() {}

    // Public function to emit the WantsToCount event with the caller's address
    function emitCountLog() public {  
        emit WantsToCount(msg.sender);  // Emit the event with the address of the caller
    }  
}