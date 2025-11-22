// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GoldOrc is AggregatorV3Interface, Ownable {

    int256 private _latestAnswer;
    uint8 private _decimals;
    string private _description;
    uint80 private _roundId;
    uint256 private _updatedAt;

    constructor(){

    }

    function updateGold(int256 amount, uint8 scale) external onlyOwner {
        _latestAnswer = amount;
        _decimals = scale;
    }

    function decimals() external view returns (uint8){
        return _decimals;
    }

    function latestRoundData()
    external
    view
    override
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    )
    {
        return (_roundId, _latestAnswer, _updatedAt, _updatedAt, _roundId);
    }

    function description() external pure returns (string memory){
        return "";
    }

    function version() external pure returns (uint256){
        return 1;
    }

    function getRoundData(
        uint80 roundId_
    ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound){
        require(roundId_ > 0, "Not pass roundId_");
        return (_roundId, _latestAnswer, _updatedAt, _updatedAt, _roundId);
    }
}
