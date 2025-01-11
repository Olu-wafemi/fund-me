// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
error NotOwner();
contract FundMe{

  address public  immutable owner; //Immutable for saving gas for variable stord only once

   address[] public funders;
   mapping(address=> uint256 amountFunded) public addresstoamountfunded;
   constructor(){
      owner = msg.sender;

   }
 function fund() public payable  { 

   funders.push(msg.sender);
   addresstoamountfunded[msg.sender]  += msg.value;
    // require(msg.value > 1e18, "didn't send enough eth");
 
    
 }

 function getConversionRate(uint256 ethAmount) public view returns(uint256){
    uint256 ethPriceinUsd = getPrice();
    uint256 ethAmoutinUsd = (ethPriceinUsd * ethAmount)/ 1e18;
    return ethAmoutinUsd;
 } 
 function getPrice() public view returns(uint256){

    AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    (, int256 price ,,,) = pricefeed.latestRoundData(); 

    return uint256(price)* 1e10;

 }
 function withdraw() public onlyOwner  {
 
   

  for(uint i = 0; i < funders.length; i++){

   address funder = funders[i];
   addresstoamountfunded[funder] = 0;
  }

  funders = new address[](0);
  (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
  require(callSuccess, "Call Failed");
  
 }

 modifier onlyOwner(){
   if(msg.sender != owner){
      revert NotOwner(); //custom errors, gas efficient
   }
  // require(msg.sender == owner, "Sender has to be owner");
   _;
 } 

}