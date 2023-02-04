// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ForceSendEth {

    address target;

    constructor(address _addr){
        target = _addr;
    }

    receive() external payable {}

    function forceSendEth() public {
        selfdestruct(payable(target));
    }
    
}
