// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./PurchaseHandler.sol";

/**
 * @title Client
 * @dev Store & retrieve value in a variable
 */

contract Client is Shared {

    //address public owner; //chi ha deployato??

    string name;
    //string id;
    bool gender;
    uint256 birth;
    string discount_n;

    uint256 scadenza;

    //uint max_purchase;
    Request insurance;

    /* come mantenere le richieste? */
    //tipo portfolio delle richieste di un cliente?
    mapping(uint => InsuranceItem) spendings;
    uint n_ins = 0;

    PurchaseHandler handler;

    //costruttore per creare un cliente 
    constructor (string memory _name, bool _gender, uint _birth, string memory _discount, address payable _handlerAddr) payable {
        
        name = _name;
        gender = _gender;
        birth = _birth;
        discount_n = _discount; //ma lo teniamo?

        handler = PurchaseHandler(_handlerAddr);

        ///ha il bool di feedback
        bool registration = handler.setClient(name, birth, discount_n);
        require(registration, "ci sono stati problemi con la registrazione");
            //console.log("problem with registration");

    }

    //TODO: mettere funzione che setta il profilo del cliente + chiede l'insurance
    //e aggiungere una funzione a parte chiamata askInsurance per gestire quelle successive?
    function requestInsurance(uint256 _maxpurchase, Type _t, uint _hoursToWait) public payable {// returns (InsuranceItem memory) {

        //InsuranceItem memory prova;

        nowTime();

        require((msg.sender).balance >= _maxpurchase, "non si possiedono abbastanza fondi");

        //uint256 total = _maxpurchase * eth_index;
        sendDeposit(payable(address(handler)), _maxpurchase);

        Request memory newRequest = Request({
            clientWallet: payable(msg.sender),
            t: _t,
            maxp: _maxpurchase, //total,
            scadenza: last_access + (3600 * _hoursToWait) /*forse si può sostituire con hours*/ 
        });

        handler.askNewInsurance(newRequest);

    }

    function addNewInsurance(uint id_R) public {

        //how to gestire num ass?        
        InsuranceItem memory newI;
        newI = handler.getProposal(id_R);
        
        spendings[n_ins] = newI;
        n_ins = n_ins + 1;

    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    //per capire cosa ariva
    fallback(bytes calldata) external payable returns(bytes memory) {}


}