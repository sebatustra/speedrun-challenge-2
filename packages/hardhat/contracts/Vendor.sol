pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amount, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountSold, uint256 ethReceived);

  uint256 public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfTokens =  tokensPerEth * msg.value;
    console.log(amountOfTokens);
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }
  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw() public onlyOwner {
    (bool sent, ) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send ether");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    yourToken.transferFrom(msg.sender, address(this), _amount);
    (bool sent, ) = msg.sender.call{value: _amount / 100}("");
    console.log(_amount / 100);
    require(sent, "Failed to send ether");
    emit SellTokens(msg.sender, _amount, _amount / 100);
  }
}
