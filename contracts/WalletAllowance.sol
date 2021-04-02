// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

// import module
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";


contract Allowance is Ownable{
    
    using SafeMath for uint;
    
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount );
    
    mapping(address => uint) public allowance;

    modifier onlyAllowed (uint _amount){
        require(isOwner() || allowance[msg.sender] <= _amount, "You are not allowed");
        _;
    }
    
    function isOwner()  internal view returns (bool){
        return owner() == msg.sender;
    }
    
    function reduceAllowance(address _who, uint _amount) internal{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
    
    function allowWidthdraw(address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = allowance[_who].add(_amount);
    }

    function renounceOwnership() public override onlyOwner{
        revert("Cannot renounce ownership here...");
    }
}

contract WalletAllowance is  Allowance{
    
    
    
    event MoneyReceived (address indexed _from, uint _amount);
    
    event MoneySpent (address indexed _beneficiary, uint amount);


    function widthdrawFunds(address payable _to, uint _amount) public onlyAllowed(_amount){
        require(_amount <= address(this).balance, "Not enough funds");
        if(!isOwner()){
            reduceAllowance(_to, _amount);
        }
        _to.transfer(_amount);
        emit MoneySpent(_to, _amount);
    }   
 
   receive() external payable {
      emit MoneyReceived(msg.sender, msg.value);      
   }
   
}