// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract Errors {

function TestRequired (uint _i) public pure returns(uint) {

    require(_i > 0, "Number must be greater than 0");

    uint result = 10 / _i;

    return result;




}




}