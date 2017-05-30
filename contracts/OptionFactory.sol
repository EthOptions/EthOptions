pragma solidity ^0.4.10;

import '../installed_contracts/zeppelin/contracts/token/ERC20.sol';
import './OptionMarket.sol';

contract OptionFactory {

  enum OptionType { Call, Put }

  OptionType public optionType;
  ERC20 public token;
  OptionMarket public optionMarket;
  address public owner;
  uint256 public premium;
  uint256 public expiry;
  uint256 public notional;
  uint256 public strike;

  function OptionFactory(OptionType _optionType, address _optionMarket, address _tokenAddress, uint256 _premium, uint256 _expiry, uint256 _strike) {
    //Register parameters with market, initial notional is zero
  }

  function createOption(uint256 _premium, uint256 _expiry, uint256 _notional, uint256 _strike) {
    //Create and collateralize call / put option with relevant parties (owner & msg.sender)
    //Should specify parameters to avoid race condition (throw if they don't match)
  }

  function updateParameters(uint256 _premium, uint256 _expiry, uint256 _strike) {
    //Update market, update parameters
  }

  function updateNotional(uint256 _notional) {
    //Adjust collateral (refund or add as appropriate)
  }

  function closeOptionFactory() {
    //Refund any collateral to owner, then destroy factory
  }

}
