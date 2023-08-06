// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract YullTypes{

    function getUint256() public pure returns(uint256){
      uint256 num ;
      assembly {
        num := 100
      }
        return num;

    }

}