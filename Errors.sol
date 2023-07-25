// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract Errors {

function TestRequired (uint _i) public pure returns(uint) {

    require(_i > 0, "Number must be greater than 0");

    uint result = 10 / _i;

    return result;




}

function testRevert (uint _i) public pure returns(uint) {

    if(_i == 0) {
        revert("Number must be greater than 0");
    }

    uint result = 10 / _i;

    return result;
}

uint public num =10;


function TestAssert () public view returns(uint) {

    assert(num == 10);

    return num;
}

function checkAssertBug () public {
    num = 20;
    // should fail
}




}