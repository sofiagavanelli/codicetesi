// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "hardhat/console.sol";

import "./PurchaseHandler.sol";
import "./Shared.sol";

contract InsuranceProvider is Shared {

    string nameP; //nome del provider

    uint insurance_index = 0;

    //dove si inseriscono i fondi (:)
    //address wallet;

    //teoricamente non serve più
    //string random = "ok"; //generatore di id?

    //fatto che ogni provider ha un handler di riferimento
    PurchaseHandler handler;
    
    mapping(uint => InsuranceItem) insurances; //assicurazioni indicizzate

    constructor (string memory nP, address payable _handlerAddr) payable {
        nameP = nP;

        handler = PurchaseHandler(_handlerAddr);

    }

    function getInsurance(uint retrieve_index) public view returns (InsuranceItem memory) { //non serve address provider, perché siamo dentro questo

        console.log('siam qua %d', retrieve_index);
        return insurances[retrieve_index];
    } //al singolare?

    //ha utilità? forse per l'handler?
    function getTotInsurances() public view returns (uint) {
        return insurance_index; 
    }

    //funzione che restituisce la migliore insurance per la richiesta fatta
    //ora c'è un solo mapping perché se ne gestiscono poche
    //POSSIBILE MIGLIORIA: DIVERSI MAPPING PER I DIVERSI TIPI -- filtro ""automatico""
    function getRequest(Request memory r) public view returns (InsuranceItem memory) {

        InsuranceItem memory winner;

        winner.price = r.maxp;

        for(uint i=0; i<insurance_index; i++) {
            
            if(insurances[i].insurance_type == r.t && insurances[i].price <= winner.price) {
                winner = insurances[i];
            }

        }

        return winner;

    }


    function setInsurance(Type t, uint256 p) public {
        //add al mapping

        InsuranceItem memory newInsurance = InsuranceItem({
            provider: payable(address(this)),
            //l'assicurazione ha bisogno di un id? provider e index dovrebbero identificarla univocamente
            //prova: index (che poi come dovrei leggerli? al massimo aggiungere "-") --> da capire
            id: "prova", 
            insurance_type: t,
            price: p * 1000000000000000000 //per renderlo in ether
        });

        insurances[insurance_index] = newInsurance;

        insurance_index = insurance_index + 1;

    }

    receive() external payable {
        //ma si cancellano? no dai
    }

    
}