// SPDX-License-Identifier: MIT*
pragma solidity ^0.8.3;

contract Event{

    //Initialize variables with Default values
    string public eventName = "BlockChain Webinar";
    string public eventDate = "2022-06-12";
    string public eventTime = "14:00"; 
    uint public eventRegistrationFee = 500000000000000000; //0.5 Ether
    address public owner; //variable to store contract owner address. 
    bool public isEventRegistrationClosed = false;
    uint public eventRegistrationClosedAt;

    //Define events
    event eventDetailsUpdated(string _name, string _date, string _time, uint _fees);
    event eventClosed(uint _eventRegistrationClosedAt);
    
    constructor(){
        owner = msg.sender; //store contract owners addresss
    }

    modifier ownerOnly() {
        require( msg.sender == owner, "This function is restricted to the contract's admin");
        _;
    }

    //This function update an event details and fire event.
    //This function is restricted to contract owner only.
    function updateEventDetails(string memory _eventName, string memory _eventDate, string memory _eventTime, uint _eventRegistrationFee) public ownerOnly{
        eventName = _eventName;
        eventDate = _eventDate;
        eventTime = _eventTime;
        eventRegistrationFee = _eventRegistrationFee;
        emit eventDetailsUpdated(_eventName,_eventDate,_eventTime,_eventRegistrationFee);
    }

    //This function mark registration as a closed & fire an eventClosed event.
    //It transfer all the avaialble fund to contract onwer's account.
    //This function is restrcited to contract owner only.
    function closeEventRegistration() public ownerOnly{
         uint balance= address(this).balance; //Get avialble balance
         if(balance>0){
            payable(owner).transfer(balance); //transfer funds to owner acccount
         }
         isEventRegistrationClosed = true;
         eventRegistrationClosedAt = block.timestamp;
         emit eventClosed(eventRegistrationClosedAt);
    }


}