// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "hardhat/console.sol";

import "./PurchaseHandler.sol";

/**
 * @title Client
 * @dev Store & retrieve value in a variable
 */

contract Client is Shared {

    string name;
    string id;
    bool gender;
    uint256 birth;
    string discount_n;

    //uint max_purchase;
    Request insurance;

    /* come mantenere le richieste? */
    
    string clientIBAN;

    PurchaseHandler handler;

    //costruttore per creare un cliente 
    constructor (string memory _name, string memory _id, bool _gender, uint _birth, string memory _discount, uint _maxpurchase, Type _t, 
        string memory _iban, address _handlerAddr) {
        name = _name;
        id = _id;
        gender = _gender;
        birth = _birth;
        discount_n = _discount;

        insurance.client = address(this);
        insurance.t = _t;
        insurance.maxp = _maxpurchase;

        clientIBAN = _iban;

        handler = PurchaseHandler(_handlerAddr);
    }

    //ma in caso di errore come fa a fare il return di un insuranceitem?? bool?
    

    function requestInsurance() public returns (InsuranceItem memory) {

        InsuranceItem memory prova;

        //ma fare solo handler.giveInsurance e poi fa handler?
        //INPUT: (address client, _cName, _cId, _cBirth, _cDiscount, _cMaxp, Type _t, _cIban)         
        if(handler.takeClient(address(this), name, id, birth, discount_n, insurance.maxp, insurance.t, clientIBAN)) {

            //ha superato il controllo
            console.log('di nuovo in client');
            //prova = handler.giveInsurance();

        }
        else{
            //non ha superato il controllo!!
        }

        return prova;

    }

    function getPendingInsurance() public {

        handler.getRequests(address(this));

    }

}