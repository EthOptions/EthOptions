pragma solidity ^0.4.10;

import '../installed_contracts/zeppelin/contracts/token/ERC20.sol';
import '../installed_contracts/zeppelin/contracts/ownership/Ownable.sol';
import './OptionFactory.sol';
import './Option.sol';

contract OptionMarket is Ownable {

  OptionFactory[] allPositions;
  mapping (address => Option[]) makerPositions;
  mapping (address => Option[]) takerPositions;
  mapping (address => OptionFactory[]) openPositions;

  //For a given address (i.e. <coinbase address>), we want to display:
  //1) Any optionFactories owned by this address:
  // - iterate over openPositions[<coinbase address>] and display
  //2) Any open option positions where we are the issuer
  // - iterate over makerPositions[<coinbase address>] and display
  //3) Any open option positions where we are the counterparty
  // - iterate over takerPositions[<coinbase address>] and display

  //For all addresses we want to display:
  //4) All optionFactories (i.e. whole market)
  // - iterate over allPositions and display if non-zero notional and expiry > now

}
