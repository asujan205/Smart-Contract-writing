// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;



contract Payable {

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }


  


function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    
    function recieve() public payable {
    }


function withdrawl (uint amount) external {
        payable(msg.sender).transfer(amount);
        (bool sent ,) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send Ether");

    }






}