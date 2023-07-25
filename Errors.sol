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

modifier checkNum (uint _i) {
    require(_i == num);
    _;
}


function TestRequireModifier (uint _i) public view checkNum(_i) returns(uint) {

    return _i;
}


error MyError(string  name );
function testCostumeError (uint _i) public pure returns(uint) {

    if(_i == 0) {
        revert MyError("Number must be greater than 0");
    }

    uint result = 10 / _i;

    return result;
}






}