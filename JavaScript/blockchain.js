const sha256 = require('crypto-js/sha256');
const secp = require("ethereum-cryptography/secp256k1");
const { keccak256 } = require("ethereum-cryptography/keccak");
const { toHex } = require("ethereum-cryptography/utils");

const TARGET_DIFFICULTY = BigInt(0x0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
const MAX_TRANSACTIONS = 10;

/*

  with blocks being mined on average every 10 minutes, the difficulty (represented in this case by TARGET_DIFFICULTY) in bitcoin is modified every 2016 blocks, or roughly every two weeks
  at that time, the difficulty is changed in an effort to maintain mining intervals close to the 10 minute threshold for each block
	
  there is a set block size restriction in Bitcoin that cannot be surpassed. Because transactions come in a variety of sizes, there is no fixed amount of transactions that can fit inside a block
  check https://en.bitcoin.it/wiki/Block_size_limit_controversy
	
*/

let mempool = [];
let transactions = [];
let index = 0;

class Block {

	constructor(id, transactions, currentHash, previousHash, nonce) {
		this.id = id;
		this.transactions = transactions;
		this.currentHash = currentHash;
		this.previousHash = previousHash;
		this.nonce = nonce;
	}

	toHash() {
		return sha256(this.id + this.transactions + this.previousHash + this.nonce).toString();
	}

	/*
	
	  - in Bitcoin, a block's header contains: the software version, a timestamp, the merkle root of its transactions, the previous block hash, and the difficulty
	  - in Bitcoin, a nonce is a 32-bit field. This means that the max size of it is 2 * 32 =  4,294,967,296. When the miner reaches this point, it can alter anything else in the block header to further boost randomness
	  - check https://en.bitcoin.it/wiki/Nonce
	  - tipically, these infos are hashed

	*/

}

class Blockchain {
	
	constructor() {
		this.chain = [new Block(index, [], sha256(index + [] + null + 0).toString(), null, 0)];
		index += 1;
	}

	addBlock(block) {
		block.previousHash = this.chain[this.chain.length - 1].toHash();
		block.currentHash = sha256(block.id + block.transactions + block.previousHash + block.nonce).toString();
		this.chain.push(block);
	}

	isValid() {
		for(let i = this.chain.length - 1; i > 0; i--) {
			var block = this.chain[i];
			var prev = this.chain[i - 1];
			if(block.previousHash.toString() !== prev.toHash().toString()) {
				return false;
			}
		} return true;
	}
	
} const blockchain = new Blockchain();

class Miner{

	mine(){

		var block = new Block(index, transactions, null, null, 0);

		for (; transactions.length < MAX_TRANSACTIONS && mempool.length > 0; transactions.push(mempool.pop())) { }

		for (; BigInt(`0x${block.toHash()}`) > TARGET_DIFFICULTY; block.nonce++) {
		} blockchain.addBlock(block);

		index += 1;

	}

}

class Node{
	
	addTransaction(transaction) { mempool.push(transaction); }

	/* 
	
	  the transaction from an user arrives in the mempool
	  (typically) the miner:
		1. will take all the transactions with the highest transaction fees from the mempool
		2. and then add them to a block and attempt to find PoW
	  check https://en.bitcoin.it/wiki/Miner_fees#Priority_transactions
	
	*/

}

class Wallet {
	
	constructor() {
		this.privateKey = secp.utils.randomPrivateKey();
	}
	
	getAddress() {
	
		return toHex(keccak256(secp.getPublicKey(toHex(this.privateKey)).slice(1)).slice(-20));
	  
		/* 
	  
		  an Ethereum address is the last 20 bytes of the hash of the public key, the first byte specifies the format of the key
		  check https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/slice
	  
		*/
	  
	}
	
}

// debug
function test(){

	let nodeTest = new Node();
	for (let i = 0; i < 5; i++) {
		
		user1 = new Wallet();
		user2 = new Wallet();
		
		value = Math.random();
		trxFee = Math.random() * 0.001;
		
		nodeTest.addTransaction({ From: user1.getAddress(), To: user2.getAddress(), Value: value, Gas: trxFee});
		
	} console.log("Mempool:",mempool);

	let minerTest = new Miner();
	for (let i = 0; i < 5; i++) { minerTest.mine(); }

	if(blockchain.isValid(blockchain)){
		console.log("\nTransactions:", transactions, "\n");
		console.dir(blockchain, {depth: null, colors: true});
	} else console.log("The blockchain is invalid");

} test();
