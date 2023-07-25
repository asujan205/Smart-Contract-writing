// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;



contract Payable {

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }


    function sendEther() public payable {
        owner.transfer(msg.value);
    }
    







}