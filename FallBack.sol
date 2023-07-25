

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract FallBack {


    // when function is not found, fallback function is called automatically
    // fallback function is used to receive ether
    // fallback function is used to call other contracts

    // fallback function is called when no other function matches


//  fallback () external payable {
//      // do something
//  }




 event Log(string func, uint gas);

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log("fallback", gasleft());
    }

    // Receive is a variant of fallback that is triggered when msg.data is empty
    receive() external payable {
        emit Log("receive", gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// fallback can optionally take bytes for input and output







contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}