<template>
    <div>
        
            <form @submit.prevent="updateEventInfo()">

                    <div class="row">
                        <label>Event Name </label>
                        <input type="text" required v-model="eventName" placeholder="Enter Event Name">
                    </div>

                    <div class="row">
                        <label>Event Date </label>
                        <input type="date" required v-model="eventDate">
                    </div>

                    <div class="row">
                        <label>Event Time </label>
                        <input type="time" required v-model="eventTime">
                    </div>

                    <div class="row">
                        <label>Registration Fee (Ether) </label>
                        <input type="number" required step="any" placeholder="Enter Registration Fee In Ether." v-model="eventRegFee">
                    </div>
                    
                    <div class="row">
                        <input type="submit" value="Update Info">
                    </div>

            </form>


    </div>
</template>

<script>
/* eslint-disable */

import EventRegistrationABI from "./../../artifacts/contracts/EventRegistration.sol/EventRegstration";
import { ethers } from "ethers";

export default{
    name : 'update-event-info',
    props : ['contractAddress'],
    data() {
            return {
                eventName : null,
                eventDate : null,
                eventTime : null,
                eventRegFee : null,
                eventRegistrationContract : null,
            }
    },
    async mounted(){
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            this.eventRegistrationContract = new ethers.Contract(this.contractAddress, EventRegistrationABI.abi, signer);
            this.eventName = await (this.eventRegistrationContract).eventName();
            this.eventDate = await (this.eventRegistrationContract).eventDate();
            this.eventTime = await (this.eventRegistrationContract).eventTime();             
            const regFees = await (this.eventRegistrationContract).eventRegistrationFee();
            this.eventRegFee  = ethers.utils.formatEther(regFees);
    },
    methods: {
            
             async updateEventInfo(){            
                try{
                    const regFee = ethers.utils.parseEther(this.eventRegFee);                    
                    const txn = await (this.eventRegistrationContract).updateEventDetails(this.eventName,this.eventDate,this.eventTime,regFee);
                    await txn.wait();
                    alert("Event Info Succefully Updated.")
                }catch(error){
                    error.message ? alert(error.messsage) : console.log(error);
                }
                    
             } 

    },
};

</script>

<style scoped>

    form .row{margin-top : 15px;}
    form div label{font-weight:bold}
    form {margin-top:20px}
</style>