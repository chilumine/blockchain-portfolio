// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import './StorageSlot.sol'; // library StorageSlot https://eips.ethereum.org/EIPS/eip-1967
import 'hardhat/console.sol'; // to have console.log from hardhat

contract Storage1 {
    uint256 x = 192; // 0x0
    uint256 y = 892; // 0x1
    // every value in the map will be in the position: keccak256(key + base)
    mapping(uint => uint) test1; // 0x2
    mapping(uint => uint) test2; // 0x3
    constructor() {
        test1[1] = 5; // keccak256(0x1 + 0x2)
        test1[2] = 3; // keccak256(0x2 + 0x2)
        test1[3] = 2; // keccak256(0x3 + 0x2)
        test2[10] = 79; // keccak256(0xA + 0x3)
        test2[21] = 91; // keccak256(0x15 + 0x3)
        test2[18] = 42; // keccak256(0x12 + 0x3)
    }
}


contract Storage2 {
    constructor(){
        // In the location keccak256('test') we store the value 256
        StorageSlot.getUint256Slot(keccak256('test')).value = 256;
    }
    function check() external view {
        console.log(StorageSlot.getUint256Slot(keccak256('test')).value); // log the value 256
    }
}
