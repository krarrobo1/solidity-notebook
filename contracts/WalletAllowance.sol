// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

// import module
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract WalletAllowance is Ownable{


    mapping(address => uint) allowance;

    uint public currentBalance;

    

    modifier onlyAllowed (uint _amount){
        require(owner() == msg.sender || allowance[msg.sender] > _amount, "You are not allowed");
        _;
    }

    function addFunds () public payable{
        currentBalance += msg.value;
    }
    
    function getFunds () public view returns(uint){
        return currentBalance;
    }

    function allowWidthdraw(address _to, uint _amount) public onlyOwner{
        allowance[_to] = _amount;
    }

    function widthdrawFunds(address payable _to, uint _amount) public onlyAllowed(_amount){
        require(_amount <= currentBalance, "The wallet has not enough funds.");
        currentBalance -= _amount;
        _to.transfer(_amount);
    }

    receive() external payable { 
       addFunds();
   }
}