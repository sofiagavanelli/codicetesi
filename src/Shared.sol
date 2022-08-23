// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
/** 
Shared for common struct, variables and functions
*/
abstract contract Shared {

    enum Type{A,B,C}

    struct InsuranceItem {
        string provider;
        string id; //l'assicurazione ha un nome?
        Type insurance_type;
        uint256 price;
    }
    
    struct Request {

        address client;

        Type t;
        uint256 maxp;
    }

    /*si usa sempre un insuranceitem
    struct Proposal {
        Type t;
        uint256 price;
        string provider;
    }*/

    /******************clientInfo(name, id, bday, discount, pending, iban) */
    struct clientInfo{

        string name;
        string id; //si può togliere no?
        //bool gender;
        uint birth;
        string discount_n;

        uint pending;
        
        //da decidere se mettere una request qui
        
        string clIBAN;
    }

    /*********funzione per generare un id per le requests */
    /*function generate_id() {
    }*/
    

}