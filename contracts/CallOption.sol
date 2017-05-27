pragma solidity ^0.4.10;

import '../installed_contracts/zeppelin/contracts/token/ERC20.sol';
import './Option.sol';

contract CallOption is Option {

	function collateralizeOption() payable onlyIssuer {
		state = State.Live;
		if (msg.value != 0) {
			throw;
		}
		token.transferFrom(issuer, this, notional);
		OptionEvent(optionType, issuer, counterparty, state, price, expiry, notional, strike);
	}

	function exerciseOption() payable onlyWhen(State.Active) onlyCounterparty {
		state = State.Exercised;
		if (block.number > expiry) {
			throw;
		}
		if (msg.value != strike * notional) {
			throw;
		}
		token.transfer(counterparty, notional);
		OptionEvent(optionType, issuer, counterparty, state, price, expiry, notional, strike);
	}

	function closeOption() notWhen(State.Active) onlyIssuer {

		state = State.Closed;

		if (state == State.Live) {
			token.transfer(issuer, notional);
		}

		if (state == State.Exercised) {
			if (!msg.sender.send(this.balance)) {
				throw;
			}
		}

		OptionEvent(optionType, issuer, counterparty, state, price, expiry, notional, strike);

		destroy();

	}

}
