// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{
 function fund() public payable  { 
    // require(msg.value > 1e18, "didn't send enough eth");

    
 }
 function getPrice() public view returns(uint256){

    AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    (, int256 price ,,,) = pricefeed.latestRoundData(); 

    return uint256(price)* 1e10;

 }
}