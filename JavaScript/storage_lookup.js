const hre = require("hardhat");
const { keccak256, hexZeroPad, toUtf8Bytes } = hre.ethers.utils;

const addr = "ADDRESS";

async function lookup(){

    // eth_getStorageAt
    // https://eips.ethereum.org/EIPS/eip-1967 ERC-1967: Proxy Storage Slots
    // https://docs.alchemy.com/docs/smart-contract-storage-layout

    /* Example for uint256 (see smart contract 1 below) */
    value = await hre.ethers.provider.getStorageAt(addr, '0x2');
    
    /* Example for mapping (see smart contract 1 below) */
    key = hexZeroPad(21, 32); // key value is 21, 32 is to pad the key value in 32 bytes (needed for Solidity)
    baseSlot = hexZeroPad(0x3, 32).slice(2); // .slice(2) is needed to remove the first two bytes (0x)
    slot = keccak256(key + baseSlot);
    console.log({key, baseSlot, slot});
    value = await hre.ethers.provider.getStorageAt(addr, slot);
    
    /* For arbitrary slot (see smart contract 2 below) */
    slot = keccak256(toUtf8Bytes('test'));
    value = await hre.ethers.provider.getStorageAt(addr, slot);

    /* Print the result (general) */
    console.log("\nValue: " + parseInt(value));

    /* For arbitrary slot, using function check() (see smart contract 2 below) */
    storage = await hre.ethers.getContractAt("Storage", addr);
    await storage.check(); // the result will be in the console.log of the node

} lookup();


/* smart contract 1

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Storage {
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

*/


/* smart contract 2

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import './StorageSlot.sol'; // the sol code is from here https://eips.ethereum.org/EIPS/eip-1967
import 'hardhat/console.sol'; // to have the console.log


contract Storage {
    constructor(){
        // In the location keccak256('test') we store the value 256
        StorageSlot.getUint256Slot(keccak256('test')).value = 256;
    }

    function check() external view {
        console.log(StorageSlot.getUint256Slot(keccak256('test')).value); // log the value 256
    }
}

*/
