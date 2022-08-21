// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Shared.sol";

contract PurchaseHandler is Shared {
    
    mapping(uint => address) providers;
    uint n_provider; //??
    mapping(address => mapping(uint => InsuranceItem)) insurances; // ma address del provider?
    mapping(address => uint) n_insurance_items; //address teoricamente del provider

    /****************vecchie cose */
    uint max_time; //è un input o una costante?
    clientInfo public currentClient;
    /*************************** */


    //input di _pool: ["0x---","0x---"] --> se in array allora gli address usano ""!!!
    constructor(/*address _controllerAddr,*/ address[] memory _prov, uint n_prov) {
        //address[] memory _pool) {

        //CONTROLLER OUT
        //controlData = Controller(_controllerAddr);

        for(uint i=0; i<n_prov; i++)
            providers[i] = _prov[i];

    }


    //quando funzionerà il client allora verrà creato l'handler e chiamato da qui
    function takeClient(string memory _cName, string memory _cId, uint _cBirth, string memory _cDiscount, uint _cMaxp, 
        string memory _cIban) public returns (bool) { //ci dovrà essere un return che dà una risposta al client

        bool feedback;

        currentClient = clientInfo(_cName, _cId, _cBirth, _cDiscount, _cMaxp, _cIban);

        console.log('riga 62 handler');

        //controller out
        //if(controlData.controlInfo(currentClient)) {
        //if(this.controlClient()) {

            feedback = true;

            console.log('feedback %d', feedback);

            return feedback;
            
        //}
        /*else{
            give bad feedback perché il controllo è andato male
            feedback = false;
            return feedback;
        }*/

    }

    function giveInsurance() public returns (InsuranceItem){

        //InsuranceItem winner;
        //winner = confrontInsurance();

        console.log("sono prima di obtain");
        obtainInsurances();
        console.log("sono dopo obtain");

        uint i = 3;

        /*uint price;
        uint len;
        len = proof.length;*/

        InsuranceItem item;


        return item;

    }

    function obtainInsurances() public view {

        uint len;
        len = providers.length;

        //address[]  temp;

        InsuranceProvider item;
        

        //mapping(uint => address) storage insurances;

        address[] memory ins;

        uint i=1;
        uint k=0;

        while(i<len) {

            item = InsuranceProvider(providers[i]);

            ins = item.getInsurances();
            uint l;
            l = ins.length;

            for(uint j=1; j<l; j++) {

                console.log("sono qui");

                insurances[j+k] = ins[j];

            }

            k = k + l;

            console.log("sono fuori");

        }

    }
    
}
