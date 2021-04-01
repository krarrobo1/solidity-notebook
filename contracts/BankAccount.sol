// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract BankAccount{
    mapping (address => uint) balanceRecieved;

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendMoney() public payable{
        balanceRecieved[msg.sender] += msg.value;
    }

    function widthdrawAllMoney(address payable _to, uint _amount) public {
        uint currentBalance = balanceRecieved[msg.sender];
        require(_amount <= currentBalance, "not enough funds.");
        balanceRecieved[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}