// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import "hardhat/console.sol";

import "./Shared.sol";
import "./InsuranceProvider.sol";

contract PurchaseHandler is Shared {
    
    mapping(uint => address payable) providers; //ok??
    uint n_providers = 0; //ok??
    mapping(uint => InsuranceItem) insurances; 

    //uint = ID REQUEST
    mapping(uint => Request) indexed_requests;
    //uint = ID REQUEST 
    mapping(uint => InsuranceItem) proposals;

    //address: CLIENT WALLET ADDRESS => (int => ID REQUEST))
    mapping(address => mapping(uint => uint)) pending_affairs;
    mapping(address => clientInfo) clients;

    mapping(address => uint256) deposits;

    //id delle request
    //tiene conto di quelle GENERALI per cui aumenta linearmente all'aumentare delle richieste - non ottimale prob
    uint id_R = 0; //adesso l'id è un int -- forse creare string

    //Request public newRequest;
    //uint id_newReq;

    /****************vecchie cose */
    //uint max_time; //è un input o una costante?
    clientInfo public newClient;
    /**************************** */

    //input di _pool: ["0x---","0x---"] --> se in array allora gli address usano ""!!!
    constructor() {
        //il costruttore setta qualcosa?
    }


    //dato l'handler si settano i ""partecipanti""
    function setProviders(address payable[] memory _prov) public {

        //se si devono settare da zero
        if(n_providers == 0) {
            n_providers = _prov.length;

            for(uint i=0; i<n_providers; i++) {
                providers[i] = _prov[i];
            }
        }
        //se invece ce ne sono già un po' e si stanno aggiungendo
        else {
            uint temp = n_providers;
            n_providers = temp + _prov.length;

            for(uint i=temp; i<n_providers; i++) {
                providers[i] = _prov[i];
            }
        }

    }


    //funzione che viene chiamata dentro la request insurance del cliente
    function takeClient(address payable _clientWallet, string memory _cName,/* string memory _cId,*/ uint _cBirth, string memory _cDiscount/*,uint _cMaxp, Type _t, 
        /*uint _hoursToWait*uint256 _expireDate*/) public returns (bool) { //ci dovrà essere un return che dà una risposta al client
        
        bool feedback;

        //questa funzione si usa solo se il client non è già registrato, se no si usa askNewInsurance()
        //da capire
        //require(bytes(clients[_clientWallet].length()) == 0, "client already registered");

        //alla fine rimuovere perché il client manda già un uint256
        //uint256 _expireDate = nowTime() + (3600*_hoursToWait);

        //seguono la struttura di clientInfo e Request da Shared.sol
        //1 => fa riferimento a clientInfo.pending che si inizializza a 1
        
        //si setta il client! tipo new registration --si setta pending a 0
        newClient = clientInfo(_cName, /*_cId,*/ _cBirth, _cDiscount, 0, _clientWallet);
        clients[_clientWallet] = newClient;

        /*currentRequest = Request(_clientWallet, _t, _cMaxp, _expireDate);

        //aggiunta nuova richiesta al mapping
        indexed_requests[id_R] = currentRequest;
        id_currentReq = id_R;
        
        //va aggiunto il client!!
        clients[_clientWallet] = currentClient;

        console.log('prova nome: %s ', clients[_clientWallet].name);

        //request gestite tramite int in aumento -- da modificare nel caso di complessità
        id_R = id_R + 1;

        pending_affairs[_clientWallet][1] = id_R;*/

        //questo feedback sarebbe da modificare => cioè con l'aggiunta del deposito è solo per segnalare che si è stati aggiunti (si può non passre dall'assegnamento)
        //oppure solo require che non sia nuovo
        feedback = true;

        return feedback;
    }


    //dopo aver settato il cliente (con la prima richiesta) -- non ha senso risettarlo!!!!!!
    //gestire input request
    function askNewInsurance(address _clientWallet, Request memory _newRequest) public payable { 

        //teoricamente se entri qui avevi i soldi necessari
        //require(deposits[_clientWallet] >= newRequest.maxp, "not enough ether sent");

        //dal mapping del client segnalo che ha aggiunto una richiesta 
        //=> aumento dei pending affairs (SOLO in numero -> utilità: per il getRequests)
        clients[_clientWallet].pending = clients[_clientWallet].pending + 1;

        //aggiunta nuova richiesta al mapping
        indexed_requests[id_R] = _newRequest;

        //perché metterla come current?
        //id_currentReq = id_R;

        //aggiornamento index del mapping
        id_R = id_R + 1;

        //per aggiungere ai pending affairs di quel client la nuova richiesta
        pending_affairs[_clientWallet][clients[_clientWallet].pending] = id_R;

        // QUI
        /*FACCIO EMIT EVENT SET TIMER CON IL TEMPO E L'ID DELLA RICHIESTA COSI POI FA JS */

        //AGGIUNTA RICHIESTA: ORA SAREBBE DA MANDARE TUTTA LA FUNZIONE CHE PORTA UNA PROPOSAL NEL MAPPING
        //no perché facciamo solo alla fine -> prof
    }

    //chiama ogni provider e gli chiede la loro MIGLIORE opzione
    //uint è l'id della richiesta!! 
    function getInsurance(uint to_control) public payable {

        nowTime();

        //bisogna decidere che request controllare!!
        //tipo random number tra 0 e id_R??
        //ora è con l'input ma NON ha senso

        //block.timestamp !!
        require(last_access > indexed_requests[to_control].scadenza, "time hasn't expired yet");

        uint j=0;
        uint i=0;

        /***** */
        while (j<n_providers) {
            
            insurances[i] = InsuranceProvider(providers[j]).getRequest(indexed_requests[to_control]);
            i++;
            j++;
            
        }

        confrontInsurances(to_control);

    }

    //date le proposte seleziono la migliore =>> MOLTI WHILE !!!
    //!!!! questa va dentro le proposals --> fa tutto una sola funzione
    function confrontInsurances(uint id_Req) public payable returns (InsuranceItem memory) { /*private?*/

        InsuranceItem memory to_buy;
        to_buy = insurances[0]; //metto la prima

        uint j=1;

        while(j<n_providers) {

            if(insurances[j].price < to_buy.price) 
                to_buy = insurances[j];

            j++;

        }

        //questa cosa adesso ha perso di senso!!
        //proposals inutile
        proposals[id_Req] = to_buy;

        sendDeposit(to_buy.provider, to_buy.price);

        uint256 change;
        address payable client = indexed_requests[id_Req].clientWallet;
        //perché il deposit del client potrebbe essere più del maxp di quella specifica richiesta == potrebbe avere altre pending!!
        change = indexed_requests[id_Req].maxp - to_buy.price; //deposits[client] 
        //restituire il resto
        sendChange(client, change, to_buy);
        //change = come ho accesso al cliente? per ottenere il suo deposito?

        //c'è il return di quella comprata: dove metterla?
        return to_buy;

    }
    //per mandare indietro quella acquistata!
    function sendChange(address payable _to, uint _price, InsuranceItem memory _bought) public payable {
        //abi.encode da capire
        (bool sent, bytes memory data) = _to.call{value: _price}(abi.encode(_bought));
        require(sent, "Failed to send Ether");
    }


    //teoricamente questa si elimina:
    /*function getNewProposal(string memory request_id, InsuranceItem memory newInsurance) public returns (address) {

        if(proposals[request_id].insurance_type == newInsurance.insurance_type && newInsurance.price < proposals[request_id].price)
            proposals[request_id] = newInsurance;

        return indexed_requests[request_id].client;

    }*/


    //funzione PER IL CLIENTE: se vuole vedere le sue richieste pending
    function getRequests(address _clientWallet) public returns (clientInfo memory) {

        //ridondante
        //clientInfo memory asking = clients[client];

        //dice che è 0
        //console.log('%d', clients[_clientWallet].pending);

        uint j=1;

        //PROBLEMA CON QUESTO MAPPING
        //console.log('%d: %d', j, pending_affairs[client][j]);

        while(j<=clients[_clientWallet].pending) { //ma perché non while(j<=clients[client].pending) {
            
            //così si dovrebbero ottenere gli id delle proprie richieste
            //console.log('num della req in attesa %d:', j);
            uint id_req = pending_affairs[_clientWallet][j];
            //console.log('id della req %d', pending_affairs[_clientWallet][j]);
            //console.log(indexed_requests[id_req]);

            j++;

        }

        //proviamo a stampare il clientInfo
        return(clients[_clientWallet]);

    }


    //TODO: AGGIUNGERE FUNZIONE CHE GUARDA LE RICHIESTE SCADUTE E FA PARTIRE IL GIOCO!
    //MA POI CHI LA CHIAMEREBBE?
    //AGGIUNGERE TEMPO DI SCADENZA

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        //console.log("%d", msg.value);
        //lo sommo a quello già presente!!
        deposits[msg.sender] = deposits[msg.sender] + msg.value;
    }
   
}

