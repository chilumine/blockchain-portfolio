// === settings ===
require('dotenv').config();
const ethers = require('ethers');

//const provider = new ethers.providers.JsonRpcProvider('GANACHE-URL'); // Ganache, or
//const provider = new ethers.providers.InfuraProvider('goerli', INFURA_API_KEY); // Infura, or
const provider = new ethers.providers.AlchemyProvider('goerli','TESTNET_ALCHEMY_KEY'); //Alchemy

const wallet = new ethers.Wallet('TESTNET_PRIVATE_KEY', provider);

const contractAddress = 'CONTRACT_ADDRESS';
const abi = 'ABI';

// === interact with a smart contract ===

async function interactWithContract() {

  const contract = new ethers.Contract(
    contractAddress, 
    abi, 
    wallet
  );

  const result = await contract.SMART_CONTRACT_FUNCTION();
  console.log(result);
  
} interactWithContract();

// === sign a transaction ===

async function signTransaction() {

  // transaction details
  const toAddress = "DEST-ADDRESS";
  const value = ethers.utils.parseEther("1.0");
  const gasLimit = 21000;
  const nonce = 0;

  const tx = {
    to: toAddress,
    value: value,
    gasLimit: gasLimit,
    nonce: nonce
  };

  const signedTx = await wallet.sign(tx);
  const transactionHash = await provider.sendTransaction(signedTx);
  console.log(transactionHash);
  
} signTransaction();
