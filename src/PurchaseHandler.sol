// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Shared.sol";

contract PurchaseHandler is Shared {
    
    mapping(uint => address) providers;
    uint n_provider; //??
    mapping(address => mapping(uint => InsuranceItem)) insurances; // ma address del provider?
    mapping(address => uint) n_insurance_items; //address teoricamente del provider

    
}
