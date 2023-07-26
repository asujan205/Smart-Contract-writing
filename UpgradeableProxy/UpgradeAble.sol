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
    address public implementation;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

fallback() external payable {

    _delegateCall(implementation);

}

function _delegateCall (address _implementation) private {

    assembly {
        calldatacopy(0x0, 0x0, calldatasize())
        let result := delegatecall(gas(), _implementation, 0x0, calldatasize(), 0x0, 0)
        returndatacopy(0x0, 0x0, returndatasize())
        switch result
        case 0 {revert(0, returndatasize())}
        default {return (0, returndatasize())}
    }

    
    
   
    
}



receive() external payable {

    _delegateCall(implementation);


}
function UpgradeTo (address _implementation) public {
    require(msg.sender == owner);
    implementation = _implementation;
}





}