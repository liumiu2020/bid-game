// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import {Transfer} from "./Transfer.sol";
import {Calculate} from "./Calculate.sol";
import {Business} from "./Business.sol";


interface Trans {
    function setWinner(Calculate.User memory winner_1) external payable;
}

contract Bid is Ownable {

    /**
     * accounts award
     */
    mapping(address => string[]) public userCollections;

    Collection[] internal collections;

    using Calculate for Calculate.User;

    using Calculate for Calculate.Category;

    uint public startTime;

    uint public endTime;

    struct Collection {
        uint id; //collection id
        string name; //collection name
        Calculate.Category category; //collection category
    }

    constructor(Collection[] memory products, uint duration) {
        delete collections;
        for (uint i = 0; i < products.length; i++) {
            collections.push(products[i]);
        }
        startTime = block.timestamp;
        endTime = startTime + duration;
    }

    event transaction(address user, uint amount);

    /**
     * bid start
     */
    function bid(Calculate.Category cat, address addr, uint incr) external view returns (uint amount) {
        require(block.timestamp >= startTime, "Not start yet");
        require(uint(cat) <= uint(Calculate.Category.Book), "Invalid Category");
        Business business = Business(addr);
        require(address(business) != address(0), "Not Strategy");
        return business.bid(incr);
    }

    function setWinner(address transferAddr, Calculate.User memory winner_2) public onlyOwner returns (bool success) {
        require(block.timestamp >= endTime, "Not Over yet");
        Trans t = Trans(transferAddr);
        t.setWinner(winner_2);
        return true;
    }
}
