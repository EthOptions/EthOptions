pragma solidity ^0.4.10;

import './Option.sol';

contract PutOption is Option {

  //Option which gives the purchaser the right, but not obligation, to sell <notional> tokens at a <strike> price up until <expiry> block number.
  function PutOption(OptionType _optionType, address _tokenAddress, uint256 _premium, uint256 _expiry, uint256 _notional, uint256 _strike)
  Option(_optionType, _tokenAddress, _premium, _expiry, _notional, _strike)
  {

  }

  //Collateralizes option with ETH
  function collateralizeOption() payable onlyIssuer {
    state = State.Live;
    //value sent must equal option price to purchase tokens
    if (msg.value != strike * notional) {
      throw;
    }
    OptionEvent(optionType, issuer, counterparty, state, premium, expiry, notional, strike);
  }

  //Exercises option - triggered by counterparty
  //Counterparty must have allocated an allowance of <notional> to this contract before calling this function
  function exerciseOption() payable onlyCounterparty {
    state = State.Exercised;
    //function must be payable since PutOption exercise requires payable
    //but for a PutOption we don't allow any value to be sent
    if (msg.value != 0) {
      throw;
    }
    //Don't allow options to be exercised after expiry
    if (block.number > expiry) {
      throw;
    }
    //Transfer tokens from counterparty to option contract
    token.transferFrom(counterparty, this, notional);
    //Transfer price for tokens to counterparty
    if (!msg.sender.send(this.balance)) {
      throw;
    }
    OptionEvent(optionType, issuer, counterparty, state, premium, expiry, notional, strike);
  }

  function closeOption() onlyIssuer {

    state = State.Closed;

    //If the option is Active, it can only be closed after expiry
    if (state == State.Active && block.number <= expiry) {
      throw;
    }

    //If contract has been exercised, or is expired, return tokens
    //NB - expiry is checked above for Active state, so not rechecked here
    if (state == State.Exercised || state == State.Active) {
      token.transfer(issuer, notional);
    }

    //If contract has been collateralized with funds, return them
    if (state == State.Live) {
      if (!msg.sender.send(this.balance)) {
        throw;
      }
    }

    OptionEvent(optionType, issuer, counterparty, state, premium, expiry, notional, strike);

    destroy();

  }

}
