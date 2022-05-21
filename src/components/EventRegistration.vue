<template>
    <div>

            <div v-if="RegistrationData['email']">

                <div class="card col-xs-12 col-sm-12 col-md-6 col-lg-5 no-padding">
                    <!-- <div class="card-header">Total Registrations</div> -->
                    <div class="card-body count reg-done">
                       Already Registered.
                    </div>
                </div>

            </div>
            <div v-else-if="isEventRegistrationClosed">

                    <div class="card col-xs-12 col-sm-12 col-md-6 col-lg-5 no-padding">
                            <!-- <div class="card-header">Total Registrations</div> -->
                            <div class="card-body count reg-closed">
                                Event Registration is closed.
                            </div>
                    </div>

            </div>
            <div v-else>

                     <div class="card col-xs-12 col-sm-12 col-md-6 col-lg-5 no-padding">
                            <div class="card-header">Registration</div>
                            <div class="card-body" style="margin:10px">                            
                                <form @submit.prevent="registration()">

                                            <div class="row form-group">
                                                <label>Name </label>
                                                <input type="text" class="form-control" required v-model="name" placeholder="Enter Your Name">
                                            </div>

                                            <div class="row form-group">
                                                <label>Email </label>
                                                <input type="email" class="form-control" required v-model="email" placeholder="Enter Email">
                                            </div>

                                            <div class="row form-group">
                                                <label>Phone </label>
                                                <input type="text" class="form-control" required v-model="phone" placeholder="Enter Phone No.">
                                            </div>
                                            
                                            
                                            <div class="row form-group">
                                                <input type="submit" class="btn btn-primary submit-btn form-control" value="Register">
                                            </div>

                                </form>
                            </div>
                     </div>


            </div>

            

    </div>
</template>

<script>
/* eslint-disable */
import EventRegistrationABI from "./../../artifacts/contracts/EventRegistration.sol/EventRegstration";
import { ethers } from "ethers";

export default{
    name : 'RegistrationComponent',
    props : ['contractAddress','connectedAccountAddress','isEventRegistrationClosed'],
    data() {
        return {
            RegistrationData : [],
            eventRegistrationContract : null,
            name : null,
            email : null,
            phone : null,
            eventRegFee : null,
        }
    },
    async mounted(){            
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        this.eventRegistrationContract = new ethers.Contract(this.contractAddress, EventRegistrationABI.abi, signer);
        this.RegistrationData =  await (this.eventRegistrationContract).registeredUsers(this.connectedAccountAddress); 
        this.eventRegFee = await (this.eventRegistrationContract).eventRegistrationFee(); 
        
    },
    methods: {    
        getDateFromTimeStamp(timeStamp){
            var date =  new Date(parseInt(timeStamp));   
            
            return date.getDate()+
            "/"+(date.getMonth()+1)+
            "/"+date.getFullYear()+
            " "+date.getHours()+
            ":"+date.getMinutes()+
            ":"+date.getSeconds();

        },        
        async registration(){                         
                try{                        
                        this.$loading(true);                   
                        const txn = await (this.eventRegistrationContract).registration(this.name,this.email,this.phone,{value:this.eventRegFee});
                        await txn.wait();
                        this.RegistrationData =  await (this.eventRegistrationContract).registeredUsers(this.connectedAccountAddress); 
                        this.$loading(false);
                        this.$toastr.s("Registration Successfully Completed."); //Display success message
                }catch(error){   
                        console.log(error);                     
                        this.$loading(false);
                        error.message ? this.$toastr.e(error.message) : console.log(error);
                }     
        }//End of function 
    },
};
</script>

<style scoped>
    .card{margin:40px auto;}
    .reg-closed{color:red}
    .reg-done{color:green}
</style>