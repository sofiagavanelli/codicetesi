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
        vm.stopBroadcast();
    }
}
