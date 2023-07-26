// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


// The Wrong way to build an Upgradeable Proxy 


contract CounterV1 {


    uint public count;

    function inc() external {
        count += 1;
    }
}
// This is One Version of the Proxy Contract


contract CounterV2 {

    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}
// This is the Second Version of the Proxy Contract

// Lets Check How its an Buggy Proxy
contract BuggyProxy {

    address public implementation;
    address public owner;

    constructor() {
        owner = msg.sender;
    }



}