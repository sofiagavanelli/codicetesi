// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "hardhat/console.sol";

import "./PurchaseHandler.sol";

/**
 * @title Client
 * @dev Store & retrieve value in a variable
 */

contract Client is Shared {

    address public owner; //chi ha deployato??

    string name;
    string id;
    bool gender;
    uint256 birth;
    string discount_n;

    uint256 scadenza;

    //uint max_purchase;
    Request insurance;

    //per l'acquisto: più che
    /*string clientIBAN;
    string clientPayment;*/
    //è meglio (se si usano gli ether!!)
    address payable wallet;

    /* come mantenere le richieste? */
    //tipo portfolio delle richieste di un cliente?

    PurchaseHandler handler;
    address payable _handler;

    //costruttore per creare un cliente 
    constructor (string memory _name, string memory _id, bool _gender, uint _birth, string memory _discount, /* uint _maxpurchase, Type _t, 
        uint _hoursToWait, /*address _wallet,*/ address payable _handlerAddr) payable {

        
        //
        //require(address(this).balance >= maxpurchase, "not enought ether, lower max price");
        //si potrebbe eliminare tutto ciò e rendere il costruttore sono per il new profile!!

        //nowTime();
        
        name = _name;
        //ma ??
        id = _id;
        gender = _gender;
        birth = _birth;
        discount_n = _discount; //ma lo teniamo?

        //ma perché tenere la struct nello storage? non ha più senso crearla nelle due funzioni? --oppure è meno dispendiosa così
        /*insurance.clientWallet = address(this);
        insurance.t = _t;
        //MOLTO brutto da vedere!!
        insurance.maxp = _maxpurchase * 1000000000000000000;
        //prova: faccio inserire le ore che vogliono aspettare e le sommo al momento in cui è stato creato --> da capire come gestire days/data precisa
        insurance.scadenza = last_access + (3600 * _hoursToWait);*/

        //console.log('scadenza: %d', insurance.scadenza);

        wallet = payable(address(this));

        console.log("%d", address(this).balance);

        _handler = _handlerAddr;
        handler = PurchaseHandler(_handlerAddr);

        ///ha il bool di feedback
        if(! handler.takeClient(wallet, name, id, birth, discount_n))
            console.log("problem with registration");

    }

    //ma in caso di errore come fa a fare il return di un insuranceitem?? bool?
    

    //TODO: mettere funzione che setta il profilo del cliente + chiede l'insurance
    //e aggiungere una funzione a parte chiamata askInsurance per gestire quelle successive?
    function requestInsurance(uint _maxpurchase, Type _t, uint _hoursToWait) public payable {// returns (InsuranceItem memory) {

        //InsuranceItem memory prova;

        nowTime();

        require(address(this).balance >= insurance.maxp, "not enough ether");

        uint256 total = _maxpurchase * 1000000000000000000;
        sendDeposit(_handler, total);

        Request memory newRequest = Request({
            clientWallet: wallet,
            t: _t,
            maxp: total,
            scadenza: last_access + (3600 * _hoursToWait)
        });

        handler.askNewInsurance(wallet, newRequest);

        //ma fare solo handler.giveInsurance e poi fa handler?
        //INPUT: (client, _cName, _cId, _cBirth, _cDiscount, _cMaxp, _t, _expireDate, _wallet)       
        //if(handler.takeClient(wallet, name, id, birth, discount_n, insurance.maxp, insurance.t, scadenza)) {

        //ha superato il controllo



        /**************require dove si mette? prima o dopo?? */
        /*console.log('di nuovo in client');

        require(address(this).balance >= insurance.maxp, "not enough ether");
            sendDeposit(_handler, insurance.maxp);
        ******************************************************/

        

        /*if(address(this).balance >= insurance.maxp)
            sendDeposit(_handler, insurance.maxp);
        else
            console.log("not enough ether");*/
            
        //aggiungere un sending del maxprice -- dani l'ha fatto

        /*}
        else{
            //non ha superato il controllo!!
            //vuol dire che non è stato accettato il cliente
            //gestire errori negli input/send eth
        }*/

        //return prova;

    }

    function getPendingInsurance() public {
        handler.getRequests(wallet);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    //per capire cosa ariva
    fallback(bytes calldata) external payable returns(bytes memory) {
        return(msg.data);
    }


}