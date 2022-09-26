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

    Client internal firstClient;
    Client internal secondClient;

    InsuranceProvider internal prov1;
    InsuranceProvider internal prov2;

    function setUp() public payable { //metto su tutti i contract

        handler = new PurchaseHandler();
        prov1 = new InsuranceProvider("prov1", payable(address(handler)));
        prov2 = new InsuranceProvider("prov2", payable(address(handler)));
        firstClient = new Client("mario", false, 120367, "prova", payable(address(handler)));
        secondClient = new Client("luisa", true, 110857, "boh", payable(address(handler)));

        //setto il block.timestamp!!
        vm.warp(1664009449);

        vm.deal(payable(address(firstClient)), 6e18);
        vm.deal(payable(address(secondClient)), 8e18);

    }

    function testProject() public payable {

        //divento provider e aggiungo delle assicurazioni --> 1
        vm.prank(address(prov1));
        prov1.setInsurance(Shared.Type(2), 3e18);
        // --> 2
        vm.prank(address(prov2));
        prov2.setInsurance(Shared.Type(2), 2e18);
        
        //richiesta del cliente
        vm.prank(address(firstClient));
        firstClient.requestInsurance(4e18, Shared.Type(2), 3);

        //proposte del provider data la richiesta --> 2
        vm.prank(address(prov2));
        prov2.setInsuranceForRequest(0, Shared.Type(2), 1e18); //ne creo una nuova apposta
        // --> 1
        //vm.prank(address(prov1));
        //prov1.putProposal(0); //do la migliore nel portfolio al momento che è quella da 1 che è uguale quindi dà errore

        //faccio passare il tempo per poter comprare
        vm.warp(block.timestamp + (3 hours));

        //se si rimuove questa chiamata il cliente NON ha accesso all'assicurazione perché NON è stata acquistata
        vm.prank(address(secondClient));
        handler.buyProposal(0);

        //se si usa secondClient dà errore perché NON è quello giusto
        //secondClient.addNewInsurance(0);
        firstClient.addNewInsurance(0);

    }

}
