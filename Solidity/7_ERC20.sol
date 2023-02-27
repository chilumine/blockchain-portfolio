// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.10;

error Unauthorized();

contract Owned {
	address public owner;

	constructor() {
		owner = msg.sender;
	}

	modifier onlyOwner(){
		if (msg.sender != owner)
			revert Unauthorized();
		_;
	}
}


contract Mortal is Owned {
	function kill() public onlyOwner{
		selfdestruct(payable(owner));
	}
}


contract SolidityToken is Mortal {

	string private constant _name = "SolidityToken";
	string private constant _symbol = "STK";

	uint8 private constant _decimals = 18;

	uint256 private constant _initialSupply = 10000;
	uint256 _totalSupply;

	mapping(address => uint256) private _balanceOf;
	mapping(address => mapping(address => uint256)) private _allowance;

	event Transfer(address indexed from, address indexed to, uint256 _value);
	event Approval(address indexed owner, address indexed spender, uint256 _value);

	constructor() {
		_totalSupply = _initialSupply * 10**uint256(_decimals);
		_balanceOf[owner] = _totalSupply;
	}

	function name() public pure returns (string memory){
		return _name;
	}

	function symbol() public pure returns (string memory){
		return _symbol;
	}

	function decimals() public pure returns (uint8){
		return _decimals;
	}

	function balanceOf(address _owner) public view returns (uint256){
		return _balanceOf[_owner];
	}

	function totalSupply() public view returns (uint256){
		return _totalSupply;
	}
	
	function transfer(address _to, uint256 _value) public returns (bool success) {
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _to, uint256 _value) public returns(bool success){
		_transferFrom(msg.sender, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
		_approve(msg.sender, _spender, _value);		
		return true;
	}

	function allowance(address _owner, address _spender) public view returns (uint256 remaining){
		return _allowance[_owner][_spender];
	}

	function _transfer(address _from, address _to, uint256 _value) internal {
		// require(to != address(0));
		assembly {
			if iszero(and(_to, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)){
				revert(0, 0)
			}
		}

		require(_balanceOf[_from] >= _value);
		require(_balanceOf[_to] + _value >= _balanceOf[_to]);
		
		uint256 previousBalances = _balanceOf[_from] + _balanceOf[_to];
		_balanceOf[_from] -= _value;
		_balanceOf[_to] += _value;
		emit Transfer(_from, _to, _value);
		
		require(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
	}

	function _approve(address _owner, address _spender, uint256 _value) internal {
		// require(owner != address(0));
		// require(spender != address(0));
		assembly {
			if iszero(and(_owner, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)){
				revert(0, 0)
			}
			if iszero(and(_spender, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)){
				revert(0, 0)
			}
		}

		_allowance[_owner][_spender] = _value;

		emit Approval(msg.sender, _spender, _value);
	}

	function _transferFrom(address _from, address _to, uint256 _value) internal {
		require(_allowance[_from][msg.sender] >= _value);
		_allowance[_from][msg.sender] -= _value;
		_transfer(_from, _to, _value);
	}

}
