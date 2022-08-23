// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "hardhat/console.sol";

import "./PurchaseHandler.sol";
import "./Shared.sol";

contract InsuranceProvider is Shared {

    string nameP; //nome del provider

    uint insurance_index = 0;

    string random = "ok"; //generatore di id?

    PurchaseHandler handler;
    
    mapping(uint => InsuranceItem) insurances; //assicurazioni indicizzate

    constructor (string memory nP, address _handlerAddr) {
        nameP = nP;

        handler = PurchaseHandler(_handlerAddr);

    }

    function getInsurance(uint retrieve_index) public view returns (InsuranceItem memory) { //non serve address provider, perché siamo dentro questo

        console.log('siam qua %d', retrieve_index);
        return insurances[retrieve_index];
    } //al singolare?

    function getIndex() public view returns (uint) {
        return insurance_index;
    }

    function getRequest(Request memory r) public view returns (InsuranceItem memory) {

        InsuranceItem memory winner;

        winner.price = r.maxp;

        for(uint i=0; i<insurance_index; i++) {
            
            if(insurances[i].insurance_type == r.t && insurances[i].price <= winner.price) {

                winner = insurances[i];

            }

        }

        return winner;

        /*else
            return err;*/ //non c'è un insurance item

    }

    /*function getPortfolio() public view returns (InsuranceItem[] memory) {
        return insurances;
    }*/

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

    function proposeInsurance(string memory request_id, InsuranceItem memory newInsurance) public {

        //handler.getNewProposal

        handler.getNewProposal(request_id, newInsurance);

    }
    
}