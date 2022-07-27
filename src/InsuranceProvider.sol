// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Shared.sol";

contract InsuranceProvider is Shared {
    
    mapping(uint => InsuranceItem) insurances;

    function getInsurance(uint insurance_index) public view returns (InsuranceItem memory) { //non serve address provider, perché siamo dentro questo
        return insurances[insurance_index];
    } //al singolare?

    function setInsurance() public {
        //add al mapping

    }
    
}