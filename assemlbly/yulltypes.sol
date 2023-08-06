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

    function getHex() public pure returns(uint256){
     uint256 x;
      assembly {
        x := 0x123
      }
        return x;

    }

// Zero index bytes32 alwys give false , mean to say   bytes32 zero will alwys returns false
  function getAssignments() external pure returns(bool) {
        bool _rep;

        bytes32 zero = bytes32("2");

        assembly {
            _rep := zero
        }

        return _rep;
    }




}