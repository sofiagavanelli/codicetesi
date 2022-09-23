// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/Test.sol";

import {Client} from "../src/Client.sol";
import {InsuranceProvider} from "../src/InsuranceProvider.sol";
import {PurchaseHandler} from "../src/PurchaseHandler.sol";
import {Shared} from "../src/Shared.sol";

contract TestProject is Test {

    //Shared.Type(int)

    PurchaseHandler internal handler;

    Client internal newClient;

    InsuranceProvider internal prov1;
    InsuranceProvider internal prov2;

    function setUp() { //metto su tutti i contract

        handler = new PurchaseHandler();

        prov1 = new InsuranceProvider("prov1", payable(address(handler)));
        prov2 = new InsuranceProvider("prov2", payable(address(handler)));

        //new Client(string memory _name,bool _gender, uint _birth, string memory _discount, address payable _handlerAddr)
        newClient = new Client("nome1", false, 120367, "prova", payable(address(handler)));

        //con uno per uno dà errore (:)
        providers = [payable(address(prov1)), payable(address(prov2))];

        handler.setProviders(providers);

        vm.deal(payable(address(newClient)), 6e18);

    }

    function testProvider() {

        //divento provider
        prank(address(prov1));
        setInsurance(Shared.Type(2), 2e18);

        prank(address(prov2));
        setInsurance(Shared.Type(2), 1e18);

    }

    function testClient() returns (IsnuranceItem memory) {

        prank(address(newClient));
        requestInsurance(1e18, Shared.Type(2),0.25);

        console.log((msg.sender).balance);

        vm.warp(0.25 * 3600);

        uint[] id_prova = getRequestsByClient(msg.sender);

        InsuranceItem acquisto;
        
        acquisto = buyProposal(id_prova[0]);

        return(acquisto);

    }


    /*funzione setup che crea e dà soldi al client
    poi funzione test purchase
    test provider con prank per cambiare indirizzo
    test client
    test provider con add proposal
    test buy insurance*/

    /*PurchaseHandler internal handler;
    Client internal newClient;

    address payable[] internal providers;

    InsuranceProvider internal prov1;
    InsuranceProvider internal prov2;

    function testUp() public {

        handler = new PurchaseHandler();

        prov1 = new InsuranceProvider("prov1", payable(address(handler)));
        prov2 = new InsuranceProvider("prov2", payable(address(handler)));

        //new Client(string memory _name,bool _gender, uint _birth, string memory _discount, address payable _handlerAddr)
        newClient = new Client("nome1", false, 120367, "prova", payable(address(handler)));

        //con uno per uno dà errore (:)
        providers = [payable(address(prov1)), payable(address(prov2))];

        handler.setProviders(providers);

        //uint _maxpurchase, Type _t, uint _hoursToWait --> Shared.Type(0<=int<=3) è il tipo della enum in shared
        newClient.requestInsurance(2, Shared.Type(2), 8);

    }*/

    /*function testExample() public {
        assertTrue(true);
    }*/

}
