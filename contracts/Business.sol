// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {GoldOrc} from "./oracle/GoldOrc.sol";
import {GameOrc} from "./oracle/GameOrc.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "hardhat/console.sol";


interface Business {

    function bid(uint amount) external view returns (uint price);
}

contract Book is Business {

    uint internal basePrice;

    constructor() {
        basePrice = 0;
    }

    /**
     * judge before charity bid
     */
    function judge(uint amount) external {
        //just bid,the first amount is base price
        if (basePrice == 0) {
            basePrice = amount;
        } else {
            basePrice += amount;
        }
    }

    /**
     * charity bid
     */
    function bid(uint amount) external view override returns (uint price) {
        require(amount == basePrice, "Not judged yet");
        //return the price
        return basePrice;
    }
}

contract Game is Business {

    /**
     * oracle (for now it's my local oracle)
     */
    GameOrc internal priceFeed;

    constructor(address feedAddr) {
        priceFeed = GameOrc(feedAddr);
    }

    /**
     * increment price
     */
    function bid(uint amount) external view override returns (uint price) {
        //with oracle game
        (,int256 basePrice,,,) = priceFeed.latestRoundData();
        return uint(basePrice) + amount;
    }
}

contract Gold is Business {

    GoldOrc internal priceFeed;

    constructor(address feedAddr) {
        priceFeed = GoldOrc(feedAddr);
    }

    /**
     * full price with dynamic rate
     * amount should be scaled
     */
    function bid(uint amount) external view override returns (uint price) {
        uint8 decimal = priceFeed.decimals();
        require(decimal % 10 == 0 || decimal == 1, "Wrong decimal, please check oracle");
        //with oracle gold rate
        (,int256 scaledRate,,,) = priceFeed.latestRoundData();
        return amount * decimal * uint(scaledRate);
    }
}
