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

    //event AskForInsurance(Request r);

    /****************vecchie cose */
    uint max_time; //è un input o una costante?
    clientInfo public currentClient;
    /**************************** */

    Request public currentRequest;


    //input di _pool: ["0x---","0x---"] --> se in array allora gli address usano ""!!!
    constructor(/*address _controllerAddr,*/ address[] memory _prov /*, uint n_prov*/) {

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
    function takeClient(string memory _cName, string memory _cId, uint _cBirth, string memory _cDiscount, uint _cMaxp, Type _t, 
        string memory _cIban) public returns (bool) { //ci dovrà essere un return che dà una risposta al client

        bool feedback;

        currentClient = clientInfo(_cName, _cId, _cBirth, _cDiscount, _cMaxp, _cIban);
        currentRequest = Request(_t, _cMaxp);

        console.log('riga 62 handler');

        //controller out
        //if(controlData.controlInfo(currentClient)) {
        //if(this.controlClient()) {

        feedback = true;

        console.log('feedback %d', feedback);

        return feedback;
            
        //}

    }

    function giveInsurance() public returns (InsuranceItem memory) {

        return (InsuranceProvider(providers[0]).getInsurance(0));

    }

    function obtainInsurances() public {

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
    
}
