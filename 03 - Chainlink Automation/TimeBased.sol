// SPDX-License-Identifier: MIT
// Specifies the license type for this contract (MIT license), ensuring compliance with open-source standards.
pragma solidity ^0.8.0;  
// Indicates that this contract is written in Solidity version 0.8.0 or later, ensuring compatibility with newer language features and security improvements.

contract TimeBased {  
    uint256 public counter;  
    // Declares a public variable `counter` of type uint256, accessible from outside the contract. 

    function count() public {  
        // Function `count` that can be called publicly to increment the `counter`.
        counter += 1;  
        // Increments `counter` by 1 each time this function is called.
    }  
}