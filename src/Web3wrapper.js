import {GetCoinbase, CheckGetweb3} from "./DappUtils.js";
import React , {Component} from 'react';
import Web3 from 'web3';
import TruffleContract from 'truffle-contract';

class Web3wrapper extends Component {
    constructor(props){
        super(props);
        this.state = {
            web3:null,
            coinbase:null
        }
    }
    componentWillMount(){
        this.redoEth(this);
    }

    redoEth(caller){
        let web3 = CheckGetweb3();
        let coinbase = GetCoinbase(web3);
        if(!web3||!coinbase){
            setTimeout(function(){caller.redoEth(caller);},100);
        }
        caller.setState({web3: web3, coinbase:coinbase});
    }
    render(){
        let web3 = this.state.web3;
        let coinbase = this.state.coinbase;
        console.log("show me the problem",web3, coinbase, web3.version.network);
        if(!web3 || !coinbase ){
            return (
                /* <Getcard web3present={!!web3} coinbasepresent={!!coinbase} /> //web3 = {!web3} loggedIn ={!coinbase} */
                <p> {!web3 && "Still loading web3!"} {!coinbase && "No account detected"} </p>
            )
        } else{
            let CallOption = new TruffleContract(require("./build/contracts/CallOption.json"));
            let Provider = new Web3.providers.constructor(web3.currentProvider);
            CallOption.setProvider(Provider);
            // CallOption.setProvider(new Web3.providers.HttpProvider("http://localhost:8545"));
            CallOption.deployed().then(function(instance) {console.log(instance);});
            return (
                    
                    <p> Got web3! </p>
                )
        }
    };
}

export default Web3wrapper