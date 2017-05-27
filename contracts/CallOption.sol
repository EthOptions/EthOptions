pragma solidity ^0.4.10;

import './Option.sol';

//Option which gives the purchaser the right, but not obligation, to buy <notional> tokens at a <strike> price up until <expiry> block number.
contract CallOption is Option {

	function CallOption(OptionType _optionType, address _tokenAddress, uint256 _premium, uint256 _expiry, uint256 _notional, uint256 _strike)
	Option(_optionType, _tokenAddress, _premium, _expiry, _notional, _strike)
	{

	}

	//Collateralizes option with tokens.
	//Issuer must have allocated an allowance of <notional> to this contract before calling this function
	function collateralizeOption() payable onlyIssuer {
		state = State.Live;
		//function must be payable since PutOption collateralization requires payable
		//but for a CallOption we don't allow any value to be sent
		if (msg.value != 0) {
			throw;
		}
		//Collateralize option with tokens
		token.transferFrom(issuer, this, notional);
		OptionEvent(optionType, issuer, counterparty, state, premium, expiry, notional, strike);
	}

	//Exercises option - triggered by counterparty
	function exerciseOption() payable onlyCounterparty {
		state = State.Exercised;
		//Don't allow options to be exercised after expiry
		if (block.number > expiry) {
			throw;
		}
		//Value sent must equal cost of tokens
		if (msg.value != strike * notional) {
			throw;
		}
		//Transfer tokens to counterparty
		//NB - ether is pulled by issuer using closeOption as a seperate transaction
		token.transfer(counterparty, notional);
		OptionEvent(optionType, issuer, counterparty, state, premium, expiry, notional, strike);
	}

	function closeOption() onlyIssuer {

		state = State.Closed;

		//If the option is Active, it can only be closed after expiry
		if (state == State.Active && block.number <= expiry) {
			throw;
		}

		//If contract has been collateralized with tokens, return them
		if (state == State.Live) {
			token.transfer(issuer, notional);
		}

		//If contract has been exercised, or is expired, return value
		//NB - expiry is checked above for Active state, so not rechecked here
		if (state == State.Exercised || state == State.Active) {
			if (!msg.sender.send(this.balance)) {
				throw;
			}
		}

		OptionEvent(optionType, issuer, counterparty, state, premium, expiry, notional, strike);

		//Contract is finished, kill it
		destroy();

	}

}
