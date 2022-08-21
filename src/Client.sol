// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//import "hardhat/console.sol";

import "./PurchaseHandler.sol";

/**SOLIDITY info:
    ADDRESS PUBLIC minter
The line address public minter; declares a state variable of type address. The address type is a 160-bit value 
that does not allow any arithmetic operations. 
    MAPPING (type => type)
The next line, mapping (address => uint) public balances; also creates a public state variable, but it is a more 
complex datatype. The mapping type maps addresses to unsigned integers.
Mappings can be seen as hash tables which are virtually initialised such that every possible key exists from the 
start and is mapped to a value whose byte-representation is all zeros. However, it is neither possible to obtain 
a list of all keys of a mapping, nor a list of all values. Record what you added to the mapping, or use it in a 
context where this is not needed. Or even better, keep a list, or use a more suitable data type.
    CONSTRUCTOR
The constructor is a special function that is executed during the creation of the contract and cannot be called 
afterwards. 
    COMMON THINGS
The msg variable (together with tx and block) is a special global variable that contains properties which allow 
access to the blockchain. msg.sender is always the address where the current (external) function call came from.
The functions that make up the contract, and that users and contracts can call are mint and send.*/

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
    uint max_purchase;
    /* come mantenere le richieste? */
    
    string clientIBAN;

    PurchaseHandler handler;

    //costruttore per creare un cliente 
    constructor (string memory _name, string memory _id, bool _gender, uint _birth, string memory _discount, uint _maxpurchase,
        string memory _iban, address _handlerAddr) {
        name = _name;
        id = _id;
        gender = _gender;
        birth = _birth;
        discount_n = _discount;
        max_purchase = _maxpurchase;

        clientIBAN = _iban;

        handler = PurchaseHandler(_handlerAddr);
    }

    //ma in caso di errore come fa a fare il return di un insuranceitem?? bool?
    

    function requestInsurance() public returns (InsuranceItem) {

        InsuranceItem prova;

        //ma fare solo handler.giveInsurance e poi fa handler?        
        if(handler.takeClient(name, id, birth, discount_n, max_purchase, clientIBAN)) {

            //ha superato il controllo
            console.log('di nuovo in client');
            prova = handler.giveInsurance();

        }
        else{
            //non ha superato il controllo!!
        }

        /*if(prova != 0)
            return prova;
        else
            console.log('non ci sono insurance con queste caratteristiche e questo prezzo');*/
        return prova;

    }

}