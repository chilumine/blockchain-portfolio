// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract MultiSig {
    address[] public owners;
    uint256 public required;
    uint256 public transactionCount;

    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
        bytes data;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmations;

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length != 0);
        require(_required != 0);
        require(_required <= _owners.length);
        owners = _owners;
        required = _required;
    }

    receive() payable external {}

    function submitTransaction(address _destination, uint256 _value, bytes memory _data) external{
        confirmTransaction(addTransaction(_destination, _value, _data));
    }

    function isOwner(address addr) internal view returns(bool) {
        for(uint256 i = 0; i < owners.length; i++) {
            if(owners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function isConfirmed(uint256 _transactionId) internal view returns(bool){
        return getConfirmationsCount(_transactionId) >= required;
    }

    function addTransaction(address _destination, uint256 _value, bytes memory _data) internal returns(uint256 transactionId){
        transactionId = transactionCount;
        transactions[transactionCount] = Transaction(_destination, _value, false, _data);
        transactionCount = transactionCount + 1;
    }

    function confirmTransaction(uint256 _transactionId) internal{
        require(isOwner(msg.sender));
        confirmations[_transactionId][msg.sender] = true;
        if(isConfirmed(_transactionId)) {
            executeTransaction(_transactionId);
        }
    }

    function getConfirmationsCount(uint256 _transactionId) internal view returns(uint256) {
        uint256 count;
        for(uint256 i = 0; i < owners.length; i++) {
            if(confirmations[_transactionId][owners[i]]) {
                count++;
            }
        }
        return count;
    }

    function executeTransaction(uint _transactionId) internal {
        require(isConfirmed(_transactionId));
        Transaction storage _tx = transactions[_transactionId];
        (bool success, ) = _tx.destination.call{ value: _tx.value }(_tx.data);
        require(success);
        _tx.executed = true;
    }
    
}
