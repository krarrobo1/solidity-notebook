// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract BankAccount{
    mapping (address => uint) balanceRecieved;
    
    address payable owner;
    
    // Only calls on contract deployment
    constructor(){
        owner = payable(msg.sender);
    }
    // Can access to store vars but not change it's state
    function getOwner() public view returns(address){
        return owner;
    }
    // Can't access to store vars at all.
    function convertWeiToEth(uint _amountInWei) public pure returns (uint){
        return _amountInWei / 1 ether;
    }
    
     // Fallback function for receive ETH when the SC dont have any function to transfer eth.
   receive() external payable { 
       receiveMoney();
   }
    
    function destroySmartContract () public{
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(owner);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function receiveMoney() public payable{
        balanceRecieved[msg.sender] += msg.value;
    }

    function widthdrawMoney(address payable _to, uint _amount) public {
        uint currentBalance = balanceRecieved[msg.sender];
        require(_amount <= currentBalance, "not enough funds.");
        balanceRecieved[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}