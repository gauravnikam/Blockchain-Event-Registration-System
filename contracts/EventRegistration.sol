// SPDX-License-Identifier: MIT*
pragma solidity ^0.8.3;

import "./Event.sol";

contract EventRegstration is Event{

    uint public totalRegisteredUsers = 0;
    uint public totalReceivedFee = 0;

    struct registeredUserDetails{
        uint id;
        string name;
        string email;
        string phone;
        uint paidFees;
        uint registrationDateTime;
    }
    mapping (address => registeredUserDetails) public registeredUsers;
    
    event registrationSuccess(address _accountAddress, uint _id, uint _registrationDateTime);

    function registration(string memory _name, string memory _email, string memory _phone) public payable {
        require(isEventRegistrationClosed==true,"Event Registration is closed.");
        require(msg.value!=eventRegistrationFee, "Please pay exact regisration fee.");
        uint currentTimeStamp = block.timestamp;
        registeredUsers[msg.sender] =  registeredUserDetails(totalRegisteredUsers,_name,_email,_phone,msg.value,currentTimeStamp);
        totalRegisteredUsers +=1;
        totalReceivedFee += msg.value;
        emit registrationSuccess(msg.sender,totalRegisteredUsers-1,currentTimeStamp);
    }



}