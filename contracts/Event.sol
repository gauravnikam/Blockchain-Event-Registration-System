// SPDX-License-Identifier: MIT*
pragma solidity ^0.8.3;

contract Event{

    string public eventName = "BlockChain Webinar";
    string public eventDate = "2022-06-12";
    string public eventTime = "14:00"; 
    uint public eventRegistrationFee = 500000000000000000; //0.5 Ether
    address public owner;
    bool public isEventRegistrationClosed = false;
    uint public eventRegistrationClosedAt;

    event eventDetailsUpdated(string _name, string _date, string _time, uint _fees);
    event eventClosed(uint _eventRegistrationClosedAt);
    
    constructor(){
        owner = msg.sender;
    }

    modifier ownerOnly() {
        require( msg.sender == owner, "This function is restricted to the contract's admin");
        _;
    }

    function updateEventDetails(string memory _eventName, string memory _eventDate, string memory _eventTime, uint _eventRegistrationFee) public ownerOnly{
        eventName = _eventName;
        eventDate = _eventDate;
        eventTime = _eventTime;
        eventRegistrationFee = _eventRegistrationFee;
        emit eventDetailsUpdated(_eventName,_eventDate,_eventTime,_eventRegistrationFee);
    }

    function closeEventRegistration() public payable ownerOnly{
         payable(owner).transfer(address(this).balance);
         isEventRegistrationClosed = true;
         eventRegistrationClosedAt = block.timestamp;
         emit eventClosed(eventRegistrationClosedAt);
    }


}