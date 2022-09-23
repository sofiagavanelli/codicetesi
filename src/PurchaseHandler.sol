// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Shared.sol";
//import "./InsuranceProvider.sol";

contract PurchaseHandler is Shared {
    
    mapping(uint => address payable) providers; 
    uint n_providers = 0; 

    //prob non serve più
    mapping(uint => InsuranceItem) insurances; 

    //id delle request
    //tiene conto di quelle GENERALI per cui aumenta linearmente all'aumentare delle richieste - non ottimale prob
    uint id_R = 0; //adesso l'id è un int -- forse creare string
    //uint = ID REQUEST
    mapping(uint => Request) public indexed_requests;
    //uint = ID REQUEST 
    mapping(uint => InsuranceItem) proposals;

    //address: CLIENT WALLET ADDRESS => (int => ID REQUEST))
    //forse poco utile
    mapping(address => mapping(uint => uint)) pending_affairs;

    //elenco clienti
    mapping(address => clientInfo) clients;

    mapping(address => uint256) deposits;

    clientInfo public newClient;

    //input di _pool: ["0x---","0x---"] --> se in array allora gli address usano ""!!!
    constructor() {
        //il costruttore setta qualcosa?
    }


    //dato l'handler si settano i ""partecipanti""
    //ma forse non ha senso settare i providers
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
    function setClient(string memory _cName, uint _cBirth, string memory _cDiscount) public returns (bool) { 
        //ci dovrà essere un return che dà una risposta al client
        
        bool feedback;
        
        //si setta il client! tipo new registration --si setta pending a 0
        address payable _client = payable(msg.sender);
        newClient = clientInfo(_cName, /*_cId,*/ _cBirth, _cDiscount, 0, _client);
        clients[_client] = newClient;

        //questo feedback sarebbe da modificare => cioè con l'aggiunta del deposito è solo per segnalare che si è stati aggiunti (si può non passre dall'assegnamento)
        //oppure solo require che non sia nuovo
        feedback = true;

        return feedback;
    }


    //dopo aver settato il cliente (con la prima richiesta) -- non ha senso risettarlo!!!!!!
    //gestire input request
    function askNewInsurance(Request memory _newRequest) public payable { 

        //teoricamente se entri qui avevi i soldi necessari
        require(deposits[msg.sender] >= _newRequest.maxp, "not enough ether sent");

        //dal mapping del client segnalo che ha aggiunto una richiesta 
        //=> aumento dei pending affairs (SOLO in numero -> utilità: per il getRequests)
        address payable _client = payable(msg.sender);
        clients[_client].pending = clients[_client].pending + 1;

        //aggiunta nuova richiesta al mapping
        indexed_requests[id_R] = _newRequest;

        //aggiornamento index del mapping
        id_R = id_R + 1;

        //per aggiungere ai pending affairs di quel client la nuova richiesta
        pending_affairs[_client][clients[_client].pending] = id_R;

    }

    function setProposal(uint id_request, InsuranceItem memory _prop) public {

        nowTime();

        //si deve ancora poter partecipare
        require(last_access < indexed_requests[id_request].scadenza, "tempo scaduto per proposte");

        //prima proposta per questa request: come fare a controllare??
        if(indexed_requests[id_request].maxp>=_prop.price && indexed_requests[id_request].t==_prop.insurance_type)
            proposals[id_request] = _prop;
        else {//non c'è già una proposta

            //se il prezzo non è inferiore non la controllo nemmeno
            require(proposals[id_request].price > _prop.price, "presente assicurazione migliore");

            if(proposals[id_request].insurance_type == _prop.insurance_type)
                proposals[id_request] = _prop; 
        }

    }

    function buyProposal(uint to_buy) public returns (InsuranceItem memory) {
        
        //require time
        nowTime();
        
        //è effettivamente passato il tempo?
        require(last_access > indexed_requests[to_buy].scadenza, "non puoi ancora comprare, tempo non scaduto");

        //si compra l'assicurazione dal provider
        sendDeposit(proposals[to_buy].provider, proposals[to_buy].price);

        uint256 change;
        address payable client = indexed_requests[to_buy].clientWallet;

        //perché il deposit del client potrebbe essere più del maxp di quella specifica richiesta == potrebbe avere altre pending!!
        change = indexed_requests[to_buy].maxp - proposals[to_buy].price; //deposits[client] 
        //restituire il resto
        sendDeposit(client, change);
        //change = come ho accesso al cliente? per ottenere il suo deposito?

        //c'è il return di quella comprata: dove metterla?
        return proposals[to_buy];

    }

    //funzione PER IL CLIENTE: se vuole vedere le sue richieste pending
    function getRequest(uint _idR) public view returns (Request memory) {

        //proviamo a stampare il clientInfo
        return(indexed_requests[_idR]);

    }

    function getRequestsByClient(address _client) public view returns (uint[] memory) {

        uint[] memory _activeReq;

        for(uint i=0; i<clients[_client].pending; i++) {
            _activeReq[i] = pending_affairs[_client][i];
        }

        return(_activeReq);

    } 

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        deposits[msg.sender] = deposits[msg.sender] + msg.value;
    }
   
}

