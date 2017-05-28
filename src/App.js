import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
// import TruffleContract from 'truffle-contract';
// import Web3 from 'web3';
import Web3wrapper from './Web3wrapper';
// var Web3 = require("web3");

// window.addEventListener('load', function() {                    
//   // Supports Metamask and Mist, and other wallets that provide 'web3'.      
//   if (typeof window.web3 !== 'undefined') {                            
//     // Use the Mist/wallet provider.                            
//     web3 = new Web3(window.web3.currentProvider);
//     MyContract.setProvider(web3.providers.HttpProvider("http://localhost:8545"));               
//   } else {                                                      
//     // No web3 detected. Show an error to the user or use Infura: https://infura.io/
//   }                                                                                                                       
// });


class App extends Component {
  // constructor(props){
  //   super(props);
  //   let web3 = new Web3.providers.HttpProvider(this.props.web3.currentProvider);
  //   // let web3 = new Web3.providers.HttpProvider("http://localhost:8545");
  //   let CallOption = new TruffleContract(require("./build/contracts/CallOption.json"));
  //   CallOption.setProvider(web3);
  //   // CallOption.setProvider(new Web3.providers.HttpProvider("http://localhost:8545"));
  //   CallOption.deployed().then(function(instance) {console.log(instance);});
  //   this.state = {
  //     web3: web3
  //   }
  // }
  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to React</h2>
        </div>
        <div className="App-intro">

          <Web3wrapper />
        </div>
      </div>
    );
  }
}

export default App;
//