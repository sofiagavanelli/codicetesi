// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

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

    function setUp() public { //metto su tutti i contract

        handler = new PurchaseHandler();

        prov1 = new InsuranceProvider("prov1", payable(address(handler)));
        prov2 = new InsuranceProvider("prov2", payable(address(handler)));

        //new Client(string memory _name,bool _gender, uint _birth, string memory _discount, address payable _handlerAddr)
        newClient = new Client("nome1", false, 120367, "prova", payable(address(handler)));

        //con uno per uno dà errore (:)
        //address payable[] memory providers;
        //providers = [payable(address(prov1)), payable(address(prov2))];

        //handler.setProviders(providers);
        //setto il block.timestamp!!
        vm.warp(1664009449);

        vm.deal(payable(address(newClient)), 6e18);

    }

    function testProject() public { // returns (Shared.InsuranceItem memory) {

        //divento provider e aggiungo delle assicurazioni --> 1
        vm.prank(address(prov1));
        prov1.setInsurance(Shared.Type(2), 2e18);
        // --> 2
        vm.prank(address(prov2));
        prov2.setInsurance(Shared.Type(2), 1e18);
        
        //richiesta del cliente
        vm.prank(address(newClient));
        newClient.requestInsurance(4e18, Shared.Type(2), 3);

        //proposte del provider data la richiesta --> 2
        vm.prank(address(prov2));
        prov2.setInsuranceForRequest(0, Shared.Type(2), 3e18); //ne creo una nuova apposta
        // --> 1
        vm.prank(address(prov1));
        prov2.putProposal(0); //do la migliore nel portfolio al momento

        //faccio passare il tempo per poter comprare
        vm.warp(block.timestamp + (3 hours));
        
        //se si rimuove questa chiamata il cliente NON ha accesso all'assicurazione perché NON è stata acquistata
        handler.buyProposal(0);

        vm.prank(address(newClient));
        newClient.addNewInsurance(0);

    }

    /*function testClientRequest() public {

        vm.prank(address(newClient));
        newClient.requestInsurance(1e18, Shared.Type(2), 3);

        //vm.prank(address(newClient));
        //console.log(address(newClient).balance);

        //uint[] memory id_prova =  handler.getRequestsByClient(address(newClient));

    }

    function testMakeProposals() public {

        console.log("dentro make proposal:");
        console.log(block.timestamp);

        vm.prank(address(prov1));
        prov1.putProposal(0); //la migliore che c'è adesso

        vm.prank(address(prov2));
        prov2.setInsuranceForRequest(0, Shared.Type(2), 3e18); //ne creo una nuova apposta

    }

    function testBuy() public returns (Shared.InsuranceItem memory) {

        //vm.warp(block.timestamp + (3600*3));
        console.log("dentro test buy");
        console.log(block.timestamp);

        Shared.InsuranceItem memory acquisto;
        
        acquisto = handler.buyProposal(0);

        return(acquisto);

    }*/

}
