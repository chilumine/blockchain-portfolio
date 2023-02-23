const hre = require("hardhat");
const { keccak256, hexZeroPad, toUtf8Bytes } = hre.ethers.utils;

const addr = "ADDRESS";

async function lookup(){

    // eth_getStorageAt
    // https://eips.ethereum.org/EIPS/eip-1967 ERC-1967: Proxy Storage Slots
    // https://docs.alchemy.com/docs/smart-contract-storage-layout

    /* Example for uint256 (see smart contract 1 below) */
    value = await hre.ethers.provider.getStorageAt(addr, '0x2');
    console.log("\nValue: " + parseInt(value));
    
    /* Example for mapping (see smart contract 1 below) */
    key = hexZeroPad(21, 32); // key value is 21, 32 is to pad the key value in 32 bytes (needed for Solidity)
    baseSlot = hexZeroPad(0x3, 32).slice(2); // .slice(2) is needed to remove the first two bytes (0x)
    slot = keccak256(key + baseSlot);
    console.log({key, baseSlot, slot});
    value = await hre.ethers.provider.getStorageAt(addr, slot);
    console.log("\nValue: " + parseInt(value));
    
    /* For arbitrary slot (see smart contract 2 below) */
    slot = keccak256(toUtf8Bytes('test'));
    value = await hre.ethers.provider.getStorageAt(addr, slot);
    console.log("\nValue: " + parseInt(value));

    /* For arbitrary slot, using function check() (see smart contract 2 below) */
    storage = await hre.ethers.getContractAt("Storage", addr);
    await storage.check(); // the result will be in the console.log of the node

} lookup();
