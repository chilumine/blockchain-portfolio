// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

error Unauthorized();

contract Owned {
	
	address public owner; // owner address

	constructor() {
		owner = msg.sender;
	}

	// this modifier will allow us to implement onlyOwner for a function
	// meaning that only the owner of the smart contract can call it
	modifier onlyOwner(){
		if (msg.sender != owner)
			revert Unauthorized();
		_; // this means: whatever code there is after onlyOwner, run it only after the requirement is met
	}
	
}

contract Mortal is Owned {
	// this function kill the smart contract
	// it withdrawals all the funds of the smart contract and makes it unusable
	function kill() public onlyOwner{
		selfdestruct(payable(owner));
	}
}

contract Lottery is Mortal {

	address payable[] players; // list of players, payable > means that can receive ether
	uint public lotteryID; // the ID of the current lottery
	mapping (uint => address payable) winnersHistory; // list of winners of the lottery. mapping is like a java obj where all the keys have the same value

	// events are a logging feature that allows developers to store data on-chain in a more searchable and efficient way than saving data to smart contract storage variables.
	// the indexed keyword to filter on event arguments
	event Transfer(
		address indexed winner, 
		uint prize
	);

	// print the balance of the player
	function getBalance() public view returns (uint) {
		return address(this).balance;
	}
	
	/* 
	   note on declarations
	   view: this function promises that no state will be changed, only read
	   pure: this function promises that no state will be changed nor read
	*/

	// print the list of players
	// memory means that the value is stored only for the duration of the function
	function getPlayers() public view returns (address payable[] memory) {
		return players;
	}

	// it returns the winner a given lotteryID
	function getWinnerByLottery(uint _lotteryID) public view returns (address payable){
		return winnersHistory[_lotteryID];
	}

	// in the context of a function, the address is the one that called that function
	// so it's different from the constructor
	function enter() public payable {

		require (
			msg.value > .01 ether,
			".01 ether to play"
		); // this enforces the user to pay at least .01 ether to join the lottery

		players.push(payable(msg.sender)); // it inserts the address of the players into the array
										   // it needs to be casted payble since the address may not be payable

	}

	// pick a winner and transfer the funds
	function pickWinner() public onlyOwner {

		uint index = getRandomNumber() % players.length;
		emit Transfer(players[index], address(this).balance);

		(bool success, ) = payable(players[index]).call {value: address(this).balance}("win");
		require(success, "Transaction failed");

		++lotteryID;

		winnersHistory[lotteryID-1] = players[index];
		
		//reset the state of the contract
		players = new address payable[](0);

	}

	// get a random number using the timestamp
	function getRandomNumber() internal view returns (uint){
		return uint(keccak256(abi.encode(owner, block.timestamp)));
	}

}
