<template>
    <div>
            <div class="card" style="margin-top:0">
                <div class="card-header">Event Info</div>
                <div class="card-body">                   
                     <form @submit.prevent="updateEventInfo()">

                        <div class="row form-group">
                            <label>Event Name </label>
                            <input type="text" class="form-control" required v-model="eventName" placeholder="Enter Event Name">
                        </div>

                        <div class="row form-group">
                            <label>Event Date </label>
                            <input type="date" class="form-control" required v-model="eventDate">
                        </div>

                        <div class="row form-group">
                            <label>Event Time </label>
                            <input type="time" class="form-control" required v-model="eventTime">
                        </div>

                        <div class="row form-group">
                            <label>Registration Fee (Ether) </label>
                            <input type="number" class="form-control" required step="any" placeholder="Enter Registration Fee In Ether." v-model="eventRegFee">
                        </div>
                                
                        <div class="row form-group">
                            <input type="submit" class="btn btn-primary submit-btn form-control" value="Update Info">
                        </div>

                    </form>


                </div>
            </div>

        
           


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
                    this.$loading(true);
                    const regFee = ethers.utils.parseEther(this.eventRegFee);                    
                    const txn = await (this.eventRegistrationContract).updateEventDetails(this.eventName,this.eventDate,this.eventTime,regFee);
                    await txn.wait();
                    this.$loading(false);
                    //alert("Event Info Succefully Updated.")
                    this.$toastr.s("Event Info Succefully Updated."); //Display success message      
                }catch(error){
                    this.$loading(false);
                    error.message ? this.$toastr.e(error.message) : console.log(error);
                }
                    
             } 

    },
};

</script>

<style scoped>
    form .row{margin-top : 15px;}
    form div label{font-weight:bold}
    form {margin:20px}
    .card-header{text-align: left;font-size: 20px;color: #000;}
    .submit-btn{width:150px}
</style>