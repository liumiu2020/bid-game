// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Transfer} from "./Transfer.sol";

library Calculate {

    struct User {
        address addr; //address
        string name; //username
        Category category; //collection category
    }

    enum Category {Game, Gold, Book}
}
