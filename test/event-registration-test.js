const { expect } = require("chai");
const { ethers } = require("hardhat");

var eventRegistrationContract;

describe("Event Registration Contract Deployment", function () {

    var updateEventDetails;

    before(async() => {
        const eventRegistration = await ethers.getContractFactory("EventRegstration");
        eventRegistrationContract = await eventRegistration.deploy();
        eventRegistrationContract = await eventRegistrationContract.deployed();
        //console.log(eventRegistrationContract.address);
    });
  
    it("Should deployed Successully", async function () {
        var eventRegistrationContractAddress = eventRegistrationContract.address;
        expect(eventRegistrationContractAddress).to.not.equal('');
        expect(eventRegistrationContractAddress).to.not.equal(0X0);
        expect(eventRegistrationContractAddress).to.not.equal(null);
        expect(eventRegistrationContractAddress).to.not.equal(undefined);    
    });

    it('Should Initialise Correct Default Event Values', async() => {
        expect(await eventRegistrationContract.eventName()).to.equal("BlockChain Webinar");
        expect(await eventRegistrationContract.eventDate()).to.equal("12/06/2022");
        expect(await eventRegistrationContract.eventTime()).to.equal("14:00");
        expect(await eventRegistrationContract.eventRegistrationFee()).to.equal("500000000000000000");
        expect(await eventRegistrationContract.isEventRegistrationClosed()).to.equal(false);
    });

});

describe("Update Event Info", function () {   
    var updateEventDetails;
    before(async() => {
        updateEventDetails = await eventRegistrationContract.updateEventDetails("NFT Webinar","13/06/2022","15:00", BigInt(700000000000000000));
    });
    it('Should Update Event Details', async() => {        
        expect(await eventRegistrationContract.eventName()).to.equal("NFT Webinar");
        expect(await eventRegistrationContract.eventDate()).to.equal("13/06/2022");
        expect(await eventRegistrationContract.eventTime()).to.equal("15:00");
        expect(await eventRegistrationContract.eventRegistrationFee()).to.equal("700000000000000000");
    });
});

describe("Event Registration", function () {   
    it('Should Register a Candidate', async() => {
        let eventRegistration = await eventRegistrationContract.registration("John Doe","johndoe@yopmail.com","8967656566",{ value : BigInt(700000000000000000) });
        eventRegistration = await eventRegistration.wait(); // 0ms, as tx is already confirmed
        var eventData = eventRegistration.events[0].args;
        //console.log(eventData);               
        expect(eventData._name).to.equal("John Doe");
        expect(eventData._email).to.equal("johndoe@yopmail.com");
        expect(eventData._phone).to.equal("8967656566");
        expect(eventData._id).to.equal("0");
    });
});


describe("Close/Stop Event Registration", function () {  
    it('Should close/stop event registration.', async() => {
        let closeEventRegistration = await eventRegistrationContract.closeEventRegistration();
        expect(await eventRegistrationContract.isEventRegistrationClosed()).to.equal(true);
    });
});