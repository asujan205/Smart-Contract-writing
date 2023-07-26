// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


// The Wrong way to build an Upgradeable Proxy 


contract CounterV1 {

    address public owner;
    address public implementation;


    uint public count;

    function inc() external {
        count += 1;
    }
}
// This is One Version of the Proxy Contract


contract CounterV2 {

    address public owner;
    address public implementation;

    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}
// This is the Second Version of the Proxy Contract

// Lets Check How its an Buggy Proxy
// contract BuggyProxy {

//     address public implementation;
//     address public owner;

//     constructor() {
//         owner = msg.sender;
//     }

// fallback() external payable {

//     _delegateCall();

// }

// function _delegateCall () private {
    
//       (bool suc , bytes memory data) = implementation.delegatecall(msg.data);
//      require(suc);
    
// }



// receive() external payable {

//     _delegateCall();


// }
// function UpgradeTo (address _implementation) public {
//     require(msg.sender == owner);
//     implementation = _implementation;
// }


// }



contract UpgradeAbleProxy {

}