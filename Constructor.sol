// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract ConstructorDemo {

    uint public num;

    constructor(uint _num) {
        num = _num;
    }

    function setNum(uint _num) public {
        num = _num;
    }

    function getNum() public view returns(uint) {
        return num;
    }


}