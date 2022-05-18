<template>
  <div id="app">
      
      <div v-if="!isConnectedToMetaMask">          
          <Button class="btn btn-success" @click="connectToMetaMask()"> Connect To Metamask </Button>
      </div>

      <div v-else>
              <label> Connected Account - </label> {{connectedAccountAddress}}
              <UpdateEventInfoComponent :contractAddress="contractAddress" v-if="contractOwner"></UpdateEventInfoComponent>          

      </div>


  </div>
</template>

<script>
/* eslint-disable */

import EventRegistrationABI from "./../artifacts/contracts/EventRegistration.sol/EventRegstration";
import { ethers } from "ethers";
import UpdateEventInfoComponent from "./components/UpdateEventInfo";

export default {
  name: 'App',
  components: {
      'UpdateEventInfoComponent' : UpdateEventInfoComponent,
  },
  data() {
    return {
      isConnectedToMetaMask : false,
      connectedAccountAddress : null,
      isContractOwner : false,
      contractAddress : "0x17c8d37a83cAef36E95b2D95E4dB0c126d486A76",
      contractOwner : null,
      eventRegistrationContract : null,
    }
  },
  async mounted(){

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
          await this.checkContractOwnerOwnership();          
      }

  },
  methods: {

      async checkContractOwnerOwnership(){
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            this.eventRegistrationContract = new ethers.Contract(this.contractAddress, EventRegistrationABI.abi, signer);
            this.contractOwner = await (this.eventRegistrationContract).owner();
        
            if((this.contractOwner).toLowerCase()==(this.connectedAccountAddress).toLowerCase()){ this.isContractOwner = true }
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
                this.checkContractOwnerOwnership();
              }
          })
          .catch(error => {
              error.message ? alert(error.messsage) : console.log(error);
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
  margin-top: 60px;
}
</style>
