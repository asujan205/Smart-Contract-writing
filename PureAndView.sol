// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;





contract PureAndView{

    uint public num;


    function ViewFunction () public view returns(uint) {

        return num;
        // num = 5; this will give error since we cannt change state variable in view function


    }


    function PureFunction (uint _num) public pure returns(uint) {

        // require(num< _num , "num should be less than _num"); this will give error since we cannt use require in pure function

        return _num;
        // return num; this will give error since we cannt return state variable in pure function
        // num=5; this will give error since we cannt change state variable in pure function



    }














}