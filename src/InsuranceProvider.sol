// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Shared.sol";

contract InsuranceProvider is Shared {

    string nameP; //nome del provider

    uint insurance_index = 0;

    string random; //generatore di id?
    
    mapping(uint => InsuranceItem) insurances; //assicurazioni indicizzate

    function getInsurance(uint retrieve_index) public view returns (InsuranceItem memory) { //non serve address provider, perché siamo dentro questo
        return insurances[retrieve_index];
    } //al singolare?

    function setInsurance(/*string memory n,*/ Type t, uint256 p) public {
        //add al mapping

        InsuranceItem memory newInsurance = InsuranceItem({
            provider: nameP,
            id: random, //l'assicurazione ha bisogno di un id? provider e index dovrebbero identificarla univocamente
            insurance_type: t,
            price: p
        });

        insurances[insurance_index] = newInsurance;

        insurance_index = insurance_index + 1;

    }
    
}