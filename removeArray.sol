// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract ArrayShift {

    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    function remove(uint _index) public {

        require(_index < numbers.length);

        for(uint i = _index; i < numbers.length-1; i++) {
            numbers[i] = numbers[i+1];
        }
        numbers.pop();


    }



}