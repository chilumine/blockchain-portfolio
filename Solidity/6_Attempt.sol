// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract Attempt {

    function makeAttempt() external {
        address otherContractAddress = 0xcF469d3BEB3Fc24cEe979eFf83BE33ed50988502;
        (bool success, ) = otherContractAddress.call(abi.encodeWithSignature("attempt()"));
        require(success);
    }
    
    function kill() external {
        selfdestruct(payable(msg.sender));
    }
    
}
