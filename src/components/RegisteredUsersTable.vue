<template>
    <div class="table-responsive col-xs-12 col-sm-10 col-md-11 col-lg-11 no-padding" v-if="loading">   
        <h4 class="reg-user-title">Registered User's</h4>
        <table class="table table-bordered" v-if="registeredUsers && registeredUsers.length>0">
            <thead>
                <th>#</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Paid Ethers</th>
                              
            </thead>
            <tbody>
                <tr v-for="user in registeredUsers" :key="user[2]">
                    <td>{{ parseInt(user[0])+1 }}</td>
                    <td>{{ user[1] }}</td>
                    <td>{{ user[2] }}</td>
                    <td>{{ user[3] }}</td>
                    <td>{{ weiToEther(user[4]) }}</td>
                </tr>
            </tbody>
        </table>
        <div style="margin-top:10px" v-else>
                <h5>No Registration's Yet.</h5>
        </div>

      
    </div>
</template>

<script>
    /* eslint-disable */
    import EventRegistrationABI from "./../../artifacts/contracts/EventRegistration.sol/EventRegstration";
    import { ethers } from "ethers";

    export default{

        name : 'ReigsteredUsersTable',
        props : ['contractAddress','connectedAccountAddress'],
        data() {
            return {
                registeredUsers : null,
                eventRegistrationContract : null,
                totalRegistrations : null,
                loading : false,
            }
        },
        async mounted(){

                const provider = new ethers.providers.Web3Provider(window.ethereum);
                const signer = provider.getSigner();
                this.eventRegistrationContract = new ethers.Contract(this.contractAddress, EventRegistrationABI.abi, signer);

                await this.fetchRegistrations();
                var self = this;

                (this.eventRegistrationContract).on("registrationSuccess", (account, id,dateTime, name, email, phone, fees) => {
                    this.fetchRegistrations();              
                });

                this.loading = true;

        },
        methods: {

            async fetchRegistrations(){
                this.totalRegistrations = await (this.eventRegistrationContract).totalRegisteredUsers();
                this.totalRegistrations = parseInt(this.totalRegistrations);
                this.registeredUsers = null;
                var data = [];
                for(var i=0;i<this.totalRegistrations;i++){
                    var address = await (this.eventRegistrationContract).registeredAddress(i);
                    data[i] = await (this.eventRegistrationContract).registeredUsers(address);                    
                }
                this.registeredUsers = data;
            },
            async pushNewRecord(data){
                var length = (this.registeredUsers).length;
                //var data =  await (this.eventRegistrationContract).registeredUsers(address);
                //console.log(address,length,data);
                this.registeredUsers[length] = data;
                this.totalRegistrations++;
            },                       
            weiToEther(wei){
                return ethers.utils.formatEther(wei);
            }

        },

    }

</script>

<style scoped>
    .reg-user-title{
        text-align: left;
        color: red;
        text-transform: uppercase;
    }
</style>