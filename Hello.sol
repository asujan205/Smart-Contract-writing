// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract HelloWorld{

    string public greet = "Hello World!";

    function setGreeting(string memory _greeting) public {
        greet = _greeting;
    }

    function say() public view returns(string memory){
        return greet;
    }


}