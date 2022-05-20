<template>
  <div id="app">

      <nav class="navbar">
            <a class="navbar-brand" href="#">Event Registration</a>
            <div class="form-inline" v-if="isConnectedToMetaMask">
              <b>  Account :  </b> &nbsp;  {{connectedAccountAddress}} &nbsp; <b v-if="isContractOwner" style="color:#fff">Admin</b>
            </div>
      </nav>
      
      <div v-if="!isConnectedToMetaMask" class="connectMetamaskBtnDiv">          
          <Button class="btn btn-success" @click="connectToMetaMask()"> Connect To Metamask </Button>
      </div>

      <div v-else>              
              <div class="row" v-if="isContractOwner">                  
                  <div class="section col-xs-12 col-sm-12 col-md-6 col-lg-6">
                      <UpdateEventInfoComponent :contractAddress="contractAddress"></UpdateEventInfoComponent>
                  </div>        
                  <div class="section col-xs-12 col-sm-12 col-md-6 col-lg-6">

                        <div class="row">
                            <div class="card col-xs-12 col-sm-12 col-md-6 col-lg-5 no-padding">
                                    <div class="card-header">Total Registrations</div>
                                    <div class="card-body count">
                                        {{totalRegistrations}}
                                    </div>
                            </div>

                            <div class="card col-xs-12 col-sm-12 col-md-6 col-lg-5 no-padding">
                                <div class="card-header">Total Received Ether's</div>
                                <div class="card-body count">
                                      {{totalReceivedFees}}
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="card col-xs-12 col-sm-10 col-md-10 col-lg-10 no-padding">
                                  <div class="card-header">Close Registration</div>
                                  <div class="card-body" v-if="!isEventRegistrationClosed">
                                      <p>Close the registration and withdrawn all the received registration fees.</p>
                                      <Button class="btn btn-success" @click="closeRegistration()">Close Registration</Button>
                                  </div>
                                  <div class="card-body" v-else>
                                      Event Registrations are closed.
                                  </div>
                            </div>
                        </div>
                    
                  </div>                  
              </div>
              <div v-else>
                  <EventRegistrationComponent :contractAddress="contractAddress" :isEventRegistrationClosed="isEventRegistrationClosed" :connectedAccountAddress="connectedAccountAddress"></EventRegistrationComponent>
              </div>
      </div>


  </div>
</template>

<script>
/* eslint-disable */

import EventRegistrationABI from "./../artifacts/contracts/EventRegistration.sol/EventRegstration";
import { ethers } from "ethers";
import UpdateEventInfoComponent from "./components/UpdateEventInfo";
import EventRegistrationComponent from "./components/EventRegistration";

export default {
  name: 'App',
  components: {
      'UpdateEventInfoComponent' : UpdateEventInfoComponent,
      'EventRegistrationComponent' : EventRegistrationComponent,
  },
  data() {
    return {
      isConnectedToMetaMask : false,
      connectedAccountAddress : null,
      isContractOwner : false,
      contractAddress : "0x53f4D533e7229fF8696079e5d05a0210D7c584CB",
      contractOwner : null,
      eventRegistrationContract : null,
      totalRegistrations : null,
      totalReceivedFees : null,
      isEventRegistrationClosed : false,
    }
  },
  async mounted(){
      this.$loading(true);
      await ethereum
      .request({ method: 'eth_accounts' })
      .then(accounts=>{          
            if(accounts.length>0){ 
              this.isConnectedToMetaMask = true; 
              this.connectedAccountAddress = accounts[0];
            }
      })
      .catch();
        
      if(this.isConnectedToMetaMask){
          await this.checkContractOwnership();          
      }
      this.$loading(false);

  },
  methods: {
      async closeRegistration(){

            if(!confirm("Are you sure you want to close the registrations ?")){
              return;
            }

            if(!this.eventRegistrationContract){
              await this.initEventRegistrationContract();
            }

            try{
                    this.$loading(true);                   
                    const txn = await (this.eventRegistrationContract).closeEventRegistration();
                    await txn.wait();
                    this.$loading(false);
                    this.isEventRegistrationClosed = true;
                    this.$toastr.s("Registration Succefully Closed."); //Display success message      
              }catch(error){
                    this.$loading(false);
                    error.message ? this.$toastr.e(error.message) : console.log(error);
              }

      },
      async initEventRegistrationContract(){
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            this.eventRegistrationContract = new ethers.Contract(this.contractAddress, EventRegistrationABI.abi, signer);
      },
      async getTotalRegistrations(){
            if(!this.eventRegistrationContract){
              await this.initEventRegistrationContract();
            }
            this.totalRegistrations = await (this.eventRegistrationContract).totalRegisteredUsers(); 
      },
      async getEventRegistrationStatus(){
            if(!this.eventRegistrationContract){
              await this.initEventRegistrationContract();
            }
            this.isEventRegistrationClosed = await (this.eventRegistrationContract).isEventRegistrationClosed(); 
      },
      async getTotalReceivedFees(){
            if(!this.eventRegistrationContract){
              await this.initEventRegistrationContract();
            }
            this.totalReceivedFees = await (this.eventRegistrationContract).totalReceivedFee(); 
            this.totalReceivedFees  = ethers.utils.formatEther(this.totalReceivedFees);
      },
      async checkContractOwnership(){
            await this.initEventRegistrationContract();
            this.contractOwner = await (this.eventRegistrationContract).owner();        
            if((this.contractOwner).toLowerCase()==(this.connectedAccountAddress).toLowerCase()){ 
               this.isContractOwner = true; 
               this.getTotalRegistrations(); 
               this.getTotalReceivedFees();
            }
            await this.getEventRegistrationStatus();
      },
      async connectToMetaMask(){
          
          if(!window.ethereum){
              alert('Metamask is not present.');
              return;
          }

          await ethereum
          .request({ method: 'eth_requestAccounts' })
          .then(account=>{              
              if(account.length>0){ 
                this.isConnectedToMetaMask = true;
                this.connectedAccountAddress = account[0];
                this.checkContractOwnership();
              }
          })
          .catch(error => {
              error.message ? this.$toastr.e(error.message) : console.log(error);
          });

      }

  },

}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
label{font-weight:bold}
.navbar{background:#000 !important;color:#007bff}
.card-header{text-align: left;font-size: 20px;color: #000;}
.section{margin-top:20px;}
.card{margin : 10px;padding:0}
.no-padding{padding:0 !important}
.card-body.count { font-size: 30px;}
.connectMetamaskBtnDiv{margin-top:20%;}
</style>

<style>
  @import 'bootstrap/dist/css/bootstrap.css';
</style>
