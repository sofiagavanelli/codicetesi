// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "hardhat/console.sol";

import "./Shared.sol";
import "./InsuranceProvider.sol";

contract PurchaseHandler is Shared {
    
    mapping(uint => address) providers; //ok??
    uint n_providers; //ok??
    /*troppo pesante da gestire
    mapping(address => mapping(uint => InsuranceItem)) insurances; // ma address del provider? */
    mapping(uint => InsuranceItem) insurances; // ma address del provider?
    //mapping(address => uint) n_insurance_items; //address teoricamente del provider (ok??)

    //string = ID REQUEST
    mapping(string => Request) indexed_requests;
    //string = ID REQUEST
    mapping(string => InsuranceItem) proposals;

    //string = ID CLIENTE (address?) => (int => ID REQUEST))
    mapping(address => mapping(uint => string)) pending_affairs;
    //string = ID CLIENTE
    mapping(address => clientInfo) clients;

    //mapping(string => mapping(string => Proposal)) pending; 
    // pending_insurances) buying_queue;

    //event AskForInsurance(Request r);

    //id delle request
    string generator = "prova";

    /****************vecchie cose */
    uint max_time; //è un input o una costante?
    clientInfo public currentClient;
    /**************************** */

    Request public currentRequest;
    string id_currentReq;


    //input di _pool: ["0x---","0x---"] --> se in array allora gli address usano ""!!!
    constructor() {/*address _controllerAddr, address[] memory _prov) {

        //CONTROLLER OUT
        //controlData = Controller(_controllerAddr);
        n_providers = _prov.length;
        for(uint i=0; i<n_providers; i++) {
            //providers[i].push(_prov[i]);
            providers[i] = _prov[i];
            //n_insurance_items[_prov[i]].push(InsuranceProvider(_prov[i]).getIndex());
            //n_insurance_items[_prov[i]]= InsuranceProvider(_prov[i]).getIndex();
        }*/

        //il costruttore setta qualcosa?

    }

    function setProviders(address[] memory _prov /*, uint n_prov*/) public {

        //CONTROLLER OUT
        //controlData = Controller(_controllerAddr);

        n_providers = _prov.length;

        for(uint i=0; i<n_providers; i++) {

            //providers[i].push(_prov[i]);
            providers[i] = _prov[i];
            //n_insurance_items[_prov[i]].push(InsuranceProvider(_prov[i]).getIndex());
            //n_insurance_items[_prov[i]]= InsuranceProvider(_prov[i]).getIndex();

        }

    }

    //quando funzionerà il client allora verrà creato l'handler e chiamato da qui
    function takeClient(address client, string memory _cName, string memory _cId, uint _cBirth, string memory _cDiscount, uint _cMaxp, Type _t, 
        string memory _cIban) public returns (bool) { //ci dovrà essere un return che dà una risposta al client

        bool feedback;

        //clientInfo(name, id, bday, discount, pending, iban) 
        currentClient = clientInfo(_cName, _cId, _cBirth, _cDiscount, 1, _cIban);
        currentRequest = Request(client, _t, _cMaxp);

        //aggiunta nuova richiesta al mapping
        indexed_requests[generator] = currentRequest;
        id_currentReq = generator;

        pending_affairs[client][1] = generator;

        //console.log('riga 62 handler');
        feedback = true;

        //console.log('feedback %d', feedback);

        return feedback;

    }

    function getInsurance(address client, Request memory newRequest) public { //returns (InsuranceItem memory) {

        /*uint n_pending;
        n_pending = clients[client].pending;*/

        clients[client].pending = clients[client].pending + 1;

        //aggiunta nuova richiesta al mapping
        indexed_requests[generator] = newRequest;
        id_currentReq = generator;

        pending_affairs[client][clients[client].pending] = generator;

        //AGGIUNTA RICHIESTA: ORA SAREBBE DA MANDARE TUTTA LA FUNZIONE CHE PORTA UNA PROPOSAL NEL MAPPING

        //return (InsuranceProvider(providers[0]).getInsurance(0));

    }

    function getBestProposals() public {

        //bisogna creare il mapping:
        //mapping(address => mapping(uint => InsuranceItem)) insurances; // ma address del provider?
        //return n_insurance_items[providers[0]];

        uint j=0;
        uint i=0;

        while (j<n_providers) {
            
            insurances[i] = InsuranceProvider(providers[j]).getRequest(currentRequest);

            console.log('%d', insurances[i].price);

            i++;
            j++;
            
        }

        //emit AskForInsurance(currentRequest);

    }
    
    function confrontInsurances() public returns (InsuranceItem memory) {

        InsuranceItem memory to_buy;

        to_buy = insurances[0]; //metto la prima

        uint j=1;

        while(j<n_providers) {

            if(insurances[j].price < to_buy.price) 
                to_buy = insurances[j];

            j++;

        }

        proposals[id_currentReq] = to_buy;

        return to_buy;

    }

    function getNewProposal(string memory request_id, InsuranceItem memory newInsurance) public returns (address) {

        if(proposals[request_id].insurance_type == newInsurance.insurance_type && newInsurance.price < proposals[request_id].price)
            proposals[request_id] = newInsurance;
        
        //emit event changed proposal?

        return indexed_requests[request_id].client;

    }

    function getRequests(address client) public {

        //ridondante
        clientInfo memory asking = clients[client];

        console.log('%d', clients[client].pending);

        uint j=1;

        while(j<=asking.pending) { //ma perché non while(j<=clients[client].pending) {
            
            //così si dovrebbero ottenere gli id delle proprie richieste
            console.log('%d: %s', j, pending_affairs[client][j]);

            j++;

        }

    }


}
