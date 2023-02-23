// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import './StorageSlot.sol'; // library StorageSlot https://eips.ethereum.org/EIPS/eip-1967

// EOA -> Proxy -> Logic1
//              -> Logic2
// https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies


contract Proxy {
    
    function changeImplementation(address _implementation) external {
        StorageSlot.getAddressSlot(keccak256("impl")).value = _implementation;
    }

    fallback() external{
        /* simple version */
        //(bool success, ) = StorageSlot.getAddressSlot(keccak256("impl")).value.delegatecall(msg.data);
        //require(success);

        // from https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies#proxy-forwarding
        address _impl = StorageSlot.getAddressSlot(keccak256("impl")).value;
        assembly {
            let ptr := mload(0x40)

            // (1) copy incoming call data
            calldatacopy(ptr, 0, calldatasize())

            // (2) forward call to logic contract
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()

            // (3) retrieve return data
            returndatacopy(ptr, 0, size)

            // (4) forward return data back to caller
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

}

// test cases
contract Logic1 {
    uint x = 0;

    function changeX(uint _x) external {
        x = _x;
    }
}

contract Logic2 {
    uint x = 0;

    function changeX(uint _x) external {
        x = _x;
    }

    function tripleX() external {
        x *= 3;
    }
}
