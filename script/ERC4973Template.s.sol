// ERC4973Template.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC4973Template} from "../src/ERC4973Template.sol";

contract DeployERC4973Template is Script {
    ERC4973Template public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new ERC4973Template();

        vm.stopBroadcast();
    }
}
