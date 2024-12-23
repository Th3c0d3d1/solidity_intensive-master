// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// https://docs.soliditylang.org/en/v0.8.16/contracts.html?highlight=inheritance#inheritance

contract Ownable {
    // Encapsulates all the logic for ownership
    // Add access control to the contract

    // State variable to store the authorized user/s (owner)
    address owner;

    // Assign the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        // Restricts access of functions to the authorized user/s (owner)
        require(msg.sender == owner, 'caller must be owner');
        _;
    }
}

contract Inheritance1 is Ownable {
    string public name = "Example 1";
    // Constructor is inherited from parent
    // Ownalbe modifier inherited from parent

    function setName(string memory _name) public onlyOwner {
        name = _name;
    }
}

contract Payable {
    // Lets the contract receive Ether
    receive() external payable {}
}

contract Inheritance2 is Ownable, Payable {
    // Inerits ownership from Ownable
    // Inherits deposit functionality from Payable

    // Function to withdraw the balance restricted to the owner
    function withdraw() public onlyOwner {
        uint256 value = address(this).balance;
        (bool sent, ) = owner.call{value: value}("");
        require(sent);
    }
}

contract Token1 {
    uint public totalSupply;

    constructor(uint _totalSupply) {
        totalSupply = _totalSupply;
    }
}

contract Inheritance3 is Token1 {
    string public name;
    string public symbol;
    uint public decimals;

    // Calls the constructor of the parent contract
    // Can now access the state variables of the parent contract
    constructor() Token1(1000000 * (10 ** 18)) {
        name = "My Token";
        symbol = "MTK";
        decimals = 18;
    }
}

contract Token2 {
    uint public totalSupply;
    string public name = "My Token";
    string public symbol = "MTK";
    uint public decimals = 18;

    mapping (address => uint) balances;

    constructor(uint _totalSupply) {
        totalSupply = _totalSupply * (10 ** 18);
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _account) virtual public view returns(uint) {
        return balances[_account];
    }
}

contract Inheritance4 is Token2 {

    constructor(uint _totalSupply) Token2(_totalSupply) {

    }

    function balanceOf(address _account) virtual override public view returns(uint) {

        // Access the parent function
        uint balance = super.balanceOf(_account);
        // Modify the return value
        return balance * 10;
    }
}
