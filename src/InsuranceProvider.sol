// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./PurchaseHandler.sol";

contract InsuranceProvider is Shared {

    string nameP; //nome del provider

    uint insurance_index = 0;

    //fatto che ogni provider ha un handler di riferimento
    PurchaseHandler handler;
    
    mapping(uint => InsuranceItem) insurances; //assicurazioni indicizzate

    constructor (string memory nP, address payable _handlerAddr) payable {
        nameP = nP;

        handler = PurchaseHandler(_handlerAddr);

    }

    //funzione che restituisce la migliore insurance per la richiesta fatta
    //ora c'è un solo mapping perché se ne gestiscono poche
    //POSSIBILE MIGLIORIA: DIVERSI MAPPING PER I DIVERSI TIPI -- filtro ""automatico""
    function putProposal(uint id_R) private { /*private: non tutti possono invocarla*/
    
        InsuranceItem memory winner;

        Request memory to_control = handler.getRequest(id_R);

        for(uint i=0; i<insurance_index; i++) {
            
            if(insurances[i].insurance_type == to_control.t && insurances[i].price <= winner.price) {
                winner = insurances[i];
            }

        }

        handler.setProposal(id_R, winner);

    }

    function setInsuranceForRequest(uint id_R, Type t, uint256 p) private { /*private: non tutti possono invocarla*/

        InsuranceItem memory newInsurance = InsuranceItem({
            provider: payable(msg.sender),
            insurance_type: t,
            price: p /* eth_index //per renderlo in ether*/
        });

        handler.setProposal(id_R, newInsurance);

    }

    function setInsurance(Type t, uint256 p) private { /*private: non tutti possono invocarla*/
        //add al mapping

        InsuranceItem memory newInsurance = InsuranceItem({
            provider: payable(msg.sender), 
            insurance_type: t,
            price: p /** eth_index*/
        });

        insurances[insurance_index] = newInsurance;

        insurance_index = insurance_index + 1;

    }

    receive() external payable {
        //ma si cancellano? no dai
    }

    
}