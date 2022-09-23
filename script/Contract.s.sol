// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Client} from "../src/Client.sol";
import {InsuranceProvider} from "../src/InsuranceProvider.sol";
import {PurchaseHandler} from "../src/PurchaseHandler.sol";
import {Shared} from "../src/Shared.sol";

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new PurchaseHandler();
        /*cast call [handleraddress: 0x5fbdb2315678afecb367f032d93f642f64180aa3] "takeClient(address,string,uint,string)(bool)" 
        0x70997970c51812dc3a010c7d01b50e0d17dc79c8 "mario" 120367 "ciao" */


        //vm.warp(uint256 timestamp)
        vm.stopBroadcast();
    }
}
