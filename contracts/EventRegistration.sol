// SPDX-License-Identifier: MIT*
pragma solidity ^0.8.3;

import "./Event.sol";

contract EventRegstration is Event{

    //Initialize variable with default values
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

    mapping (uint => address) public registeredAddress; //This map keeps track of account address of registered users
    mapping (address => registeredUserDetails) public registeredUsers; //This map contains details info of registered user.
    
    event registrationSuccess(address _accountAddress, uint _id, uint _registrationDateTime, string _name, string _email, string _phone, uint fees);

    function registration(string memory _name, string memory _email, string memory _phone) public payable {
        require(registeredUsers[msg.sender].registrationDateTime == 0,"You already registered."); //Make sure user is not already register.
        require(isEventRegistrationClosed==false,"Event Registration is closed."); //Make sure registrations are not closed.
        require(msg.value==eventRegistrationFee, "Please pay exact regisration fee."); //make sure paid amount is equal to registration fee.
        uint currentTimeStamp = block.timestamp;
        registeredAddress[totalRegisteredUsers] = msg.sender;
        registeredUsers[msg.sender] =  registeredUserDetails(totalRegisteredUsers,_name,_email,_phone,msg.value,currentTimeStamp);
        totalRegisteredUsers +=1; 
        totalReceivedFee += msg.value;
        emit registrationSuccess(msg.sender,totalRegisteredUsers-1,currentTimeStamp,_name,_email,_phone,msg.value);
    }



}