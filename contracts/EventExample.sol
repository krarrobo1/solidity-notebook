// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

/**
    - Used for return values from transactions.
    - Used externally to trigger functionality
    - Used as a cheap data storage
 */
contract EventExample {

 mapping(address => uint) public tokenBalance;

 constructor() {
    tokenBalance[msg.sender] = 100;
 }

 event TokensSent(address _from, address _to, uint _amount);

 function sendToken(address _to, uint _amount) public returns(bool) {
    require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
    assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
    assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
    tokenBalance[msg.sender] -= _amount;
    tokenBalance[_to] += _amount;

    emit TokensSent(msg.sender, _to, _amount);

    return true;
 }

}