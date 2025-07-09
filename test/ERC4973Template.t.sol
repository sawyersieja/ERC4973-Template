// ERC4973Template.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC4973Template} from "../src/ERC4973Template.sol";

contract ERC4973TemplateTest is Test {
    ERC4973Template public token;

    function setUp() public {
        token = new ERC4973Template();
    }
}
