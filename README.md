# blockchain-portfolio

### <ins>Index</ins>
- [Resources](#resources)
- [Tools](#tools)
- [Code](#code)
- [Attack techniques](#attack-techniques)
  - [Integer Overflow / Underflow](#integer-overflow--underflow)
  - [Re-entrancy attacks](#re-entrancy-attacks)



## Resources

- [Web3 Security Library](https://github.com/immunefi-team/Web3-Security-Library)
- [A Comprehensive Smart Contract Audit Readiness Guide](https://learn.openzeppelin.com/security-audits/readiness-guide)
- [Blockchain Security Audit List](https://github.com/0xNazgul/Blockchain-Security-Audit-List)

**Vulnerabilities**
- [SWC Registry](https://swcregistry.io/)
- [All known smart contract-side and user-side attacks and vulnerabilities in Web3.0, DeFi, NFT and Metaverse + Bonus](https://telegra.ph/All-known-smart-contract-side-and-user-side-attacks-and-vulnerabilities-in-Web30--DeFi-03-31)
- [c4-common-issues](https://github.com/byterocket/c4-common-issues)

**Updates / News**
- [rekt.news](https://rekt.news/)
- [DeFi Hacks Analysis - Root Cause](https://wooded-meter-1d8.notion.site/0e85e02c5ed34df3855ea9f3ca40f53b?v=22e5e2c506ef4caeb40b4f78e23517ee)
- [Blockchain Threat Intelligence](https://newsletter.blockthreat.io/)

**Blogs**
- [Immunefi's blog](https://immunefi.medium.com/)
- [OpenZeppelin's blog](https://blog.openzeppelin.com/)
- [Halborn's blog](https://halborn.com/blog/)
- [PWNING](https://pwning.mirror.xyz/)



## Tools

**Blockchain exploration**
- [Metamask](https://metamask.io/)
- [Etherscan.io](https://etherscan.io)
- [Bitquery](https://explorer.bitquery.io/)

**Development Environment**
- [Solidity Visual Developer](https://marketplace.visualstudio.com/items?itemName=tintinweb.solidity-visual-auditor)
- [Remix](https://remix-project.org/)
- [Truffle Suite](https://trufflesuite.com/docs/)
  - [Ganache](https://github.com/trufflesuite/ganache)

**Libraries**
- [web3.js](https://web3js.readthedocs.io/)
  web3.js is very useful for interacting with a smart contract and its APIs. Install it by using the command `npm install web3`. To use it in Node.js and interact with a contract, use the following commands:
  ```javascript
   1: node;
   2: const Web3 = require('web3');
   3: const URL = "http://localhost:8545"; //This is the URL where the contract is deployed, insert the url from Ganache
   4: const web3 = new Web3(URL);
   5: accounts = web3.eth.getAccounts();
   6: var account;
   7: accounts.then((v) => {(this.account = v[1])});
   8: const address = "<CONTRACT_ADDRESS>"; //Copy and paste the Contract Address
   9: const abi = "<ABI>"; //Copy and paste the ABI of the Smart Contract
  10: const contract = new web3.eth.Contract(abi, address).
  ```
- [ethers](https://docs.ethers.org/)
  ethers is a JavaScript library for interacting with Ethereum blockchain and smart contracts. It provides a simple, lightweight interface for making calls to smart contracts, sending transactions, and listening for events on the Ethereum network. Install it with the command `npm install ethers`. An example is [_ethers.js](JavaScript/_ethers.js)

**Vulnerability scanners & others**
- [Slither](https://github.com/crytic/slither)
- [MythX](https://mythx.io/)
- [C4udit](https://github.com/byterocket/c4udit)
- [ERC20 Verifier](https://erc20-verifier.openzeppelin.com/)



## Code

**Solidity**
- [1_Lottery-BlockVariable.sol](Solidity/1_Lottery-BlockVariable.sol) an example of a smart contract for a lottery system written in Solidity, using `block.timestamp` for randomness
- [6_Attempt.sol](Solidity/6_Attempt.sol) deployed at [0x220DBDB08718cF4FF08Dc3520C75837ad59D8b18](https://goerli.etherscan.io/address/0x220dbdb08718cf4ff08dc3520c75837ad59d8b18) to win [this challenge](https://goerli.etherscan.io/address/0xcF469d3BEB3Fc24cEe979eFf83BE33ed50988502#code)
- [7_ERC20.sol](Solidity/7_ERC20.sol) smart contract for an ERC20 token (see: [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20) and [openzeppelin-contracts/ERC20.sol](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/token/ERC20/ERC20.sol))
- [8_Telephone-attacker.sol](Solidity/8_Telephone-attacker.sol) to solve the [4. Telephone challenge](https://ethernaut.openzeppelin.com/level/4) from Ethernaut

**JavaScript**
- [digitalSignatures.js](JavaScript/digitalSignatures.js) is a simulation of public key cryptography
- [blockchain.js](JavaScript/blockchain.js) is a simple Proof of Work blockchain simulation
- [blockchain-explorer.html](JavaScript/blockchain-explorer.html) a simple Ethereum Blockchain Explorer, built using [Ethers](https://docs.ethers.org/) and [Infura](https://www.infura.io/)

**Resources**

- [Clean Contracts - a guide on smart contract patterns & practices](https://www.useweb3.xyz/guides/clean-contracts)
- [Smart Contract Security](https://ethereum.org/en/developers/docs/smart-contracts/security/)
- [Ethereum Smart Contract Security Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- [Ethereum VM (EVM) Opcodes and Instruction Reference](https://github.com/crytic/evm-opcodes)



## Attack techniques

### <ins>Integer Overflow / Underflow</ins>

**Integer Overflow** happens because the arithmetic value of the operation exceeds the maximum size of the variable value type. An example: the variable `amount` is `uint256`. It supports numeric values from 0 to 2<sup>256</sup>. This means that a value like `0x8000000000000000000000000000000000000000000000000000000000000000` corresponding to the decimal value `57896044618658097711785492504343953926634992332820282019728792003956564819968` received in the input for the variable `amount` would trigger a Integer Overflow since it exceeds the maximum value supported.

An example: [Beauty Chain exploit](https://etherscan.io/tx/0xad89ff16fd1ebe3a0a7cf4ed282302c06626c1af33221ebe0d3a470aba4a660f). An input like `["<ADDR_1>","<ADDR_2>"], 0x8000000000000000000000000000000000000000000000000000000000000000` for the function `batchTransfer` would trigger this vulnerability.

**Integer Underflow** happens in the exact opposite of the overflow error. It error occurs when you go below the minimum amount. This triggers the system to bring you right back up to maximum value instead of reverting to zero. For example, injecting the value `-1` in a `uint256` variable that stores the value `0` will result in the number 255.

#### Remediation

To fix this vulnerability, and other integer overflows and underflows, the smart contract can import and use the [SafeMath library by OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts).

```solidity
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
```

**Note**: Since version `0.8.0` Solidity automatically reverts on integer overflow and underflow instead of circling the value back to zero.


### <ins>Re-entrancy attacks</ins>

A Reentrancy vulnerability is a type of attack to drain the bit-by-bit liquidity of a contract with an insecure code-writing pattern.

An incorrect flow looks like this:
- It verifies that the user has a sufficient balance to execute the transaction
- Sends the funds to the user
- If the operation is successful, the contract updates the user's balance

The problem arises when a contract invokes this operation instead of a user. This can create code that generates a loop, which means that an attacker can invoke the withdrawal function many times because it is the same balance that is checked as the initial value.

An example of a vulnerable function
```Solidity
function withdraw(uint withdrawAmount) public returns (uint) {
		require(withdrawAmount <= balances[msg.sender]);
		msg.sender.call.value(withdrawAmount)("");
		balances[msg.sender] -= withdrawAmount;
		return balances[msg.sender];
}
```

#### Remediation

Implement Checks Effects Interactions Pattern: A secure code-writing pattern that prevents an attacker from creating loops that allow him to re-enter the contract multiple times without blocking.

- Verify that the requirements are met before continuing the execution;
- Update balances and make changes before interacting with an external actor;
- Finally, after the transaction has been validated and the changes have been made, interactions with the external entity are allowed.

#### Resource

- [A Historical Collection of Reentrancy Attacks](https://github.com/pcaversaccio/reentrancy-attacks)
