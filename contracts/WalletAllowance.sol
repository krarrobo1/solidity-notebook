// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

// import module
import "./Owned.sol";

contract WalletAllowance is Owned{

    mapping (address => bool) allowedUsers;

    mapping(address => uint) allowedAmmount;

    uint public currentBalance = 0;

    modifier onlyOwner {
        require(msg.sender == owner, "You are not allowed");
        _;
    }

    modifier onlyUser {
        require(allowedUsers[msg.sender] == false, "You are not allowed to widthdraw any funds");
        _;
    }

    function addFunds () public payable{
        currentBalance += msg.value;
    }

    function allowWidthdraw(address _to) public onlyOwner{
        allowedUsers[_to] = true;
    }

    function widthdrawFunds(address payable _to, uint _amount) public onlyUser{
        require(_amount <= currentBalance, "The wallet has not enough funds.");
        currentBalance -= _amount;
        _to.transfer(_amount);
    }

    receive() external payable { 
       addFunds();
   }
}