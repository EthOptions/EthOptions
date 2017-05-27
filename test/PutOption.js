var PutOption = artifacts.require("./PutOption.sol");
var SimpleToken = artifacts.require("./SimpleToken.sol");

contract('PutOption', function(accounts) {
  var account_one = web3.eth.accounts[0];
  it("should create, collateralize then close an option", function() {
    var simpleToken;
    var putOption;
    return SimpleToken.deployed().then(function(instance) {
      simpleToken = instance;
      return PutOption.new(1, simpleToken.address, 2000, 1999, 250, 35);
    }).then(function(instance) {
      putOption = instance;
      return putOption.state.call();
    }).then(function(state) {
      assert.equal(state.toNumber(), 0, "contract should be pending");
      return putOption.issuer.call();
    }).then(function(issuer) {
      assert.equal(issuer, account_one, "issuer should be account one")
      return putOption.collateralizeOption({value: 250 * 35})
    }).then(function(txId) {
      return putOption.state.call();
    }).then(function(state) {
      assert.equal(state.toNumber(), 1, "contract should be active")
      return putOption.closeOption();
    }).then(function(txId) {
      return putOption.state.call();
    }).then(function(state) {
      assert.equal(state.toNumber(), 0, "contract should be destroyed (no state)")
      return putOption.issuer.call();
    }).then(function(issuer) {
      assert.equal(issuer, "0x", "contract should be destroyed (no issuer)")
    });
  });
});
