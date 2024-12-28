// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DeadmanSwitch {
    address payable public beneficiary;
    address public owner;
    uint public lastAliveBlock;

    constructor(address payable _beneficiary) {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        beneficiary = _beneficiary;
        owner = msg.sender;
        lastAliveBlock = block.number; // Initialize with the block number at deployment
    }

    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function still_alive() public {
        require(msg.sender == owner, "Only the owner can call this function");
        lastAliveBlock = block.number;
    }
//checkswitch function will transfer the contract balance to benficiary account. Anyone can call checkswitch function so that funds remain safe even after owner is not active
    function checkSwitch() public {
        require(block.number >= lastAliveBlock+10 , "Owner is still active");
        beneficiary.transfer(getBalance());
    }

    function currentBlock() public view returns (uint256) {
        return block.number;
    }
}