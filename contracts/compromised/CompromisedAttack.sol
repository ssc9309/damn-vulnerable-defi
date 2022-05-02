pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract CompromisedAttack {
  address private _oracle;
  constructor(address oracle) {
    _oracle = oracle;
  }

  function attack() external {
    (bool isGetPrice, bytes memory priceResult) = _oracle.call(
      abi.encodeWithSignature("getMedianPrice(string)", "DVNFT")
    );

    (uint256 price) = abi.decode(priceResult, (uint256));

    console.log("price", price);
  }
}
