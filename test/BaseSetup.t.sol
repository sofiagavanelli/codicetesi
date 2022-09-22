// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Client} from "../src/Client.sol";
import {InsuranceProvider} from "../src/InsuranceProvider.sol";
import {PurchaseHandler} from "../src/PurchaseHandler.sol";
import {Shared} from "../src/Shared.sol";

contract BaseSetup is Test {

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
