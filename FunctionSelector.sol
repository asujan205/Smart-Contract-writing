
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Receiver {
    event Log(bytes data);

    function transfer(address _to ,uint amount )external {

        (bool success, bytes memory data) = _to.call{value:amount}("");
        require(success);
        emit Log(data);
      


    }
}

contract FunctionSelector {

    function getSelector(string calldata _func) external pure returns(bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }

}