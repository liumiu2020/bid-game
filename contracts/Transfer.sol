// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import {Calculate} from "./Calculate.sol";

contract Transfer is Ownable {

    /**
     * accounts amount
     */
    mapping(address => uint) public accounts;

    address[] public users;

    mapping(address => bool) private userExists;

    address public winner;

    using Calculate for Calculate.User;

    constructor(){
    }

    function setWinner(Calculate.User memory winner_1) external {
        winner = winner_1.addr;
    }

    /**
     * registry and participate by deposit amount(by front end)
     */
    function setAmount() external payable {
        require(msg.value > 0, "Your amount is not enough to participate");
        userExists[msg.sender] = true;
        users.push(msg.sender);
        //set bid pool
        accounts[msg.sender] = accounts[msg.sender] + msg.value;
    }

    /**
     * transaction over and fee back to participants
     */
    function release() public onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            address user = users[i];
            uint amount = accounts[user];
            if (amount > 0) {
                (bool res,) = user.call{value: amount}("");
                require(res, "release failed, rollback");
                //clear account
                clearUser(user);
            }
        }
    }

    /**
     * if final pay unsuccessfully due to user's amount manage problem
     */
    function fine() external onlyOwner {
        require(winner != address(0), "Winner not come up yet");
        if (winner.balance < accounts[winner]) {
            //fine the diff
            accounts[winner] = winner.balance;
            if (winner.balance == 0) {
                clearUser(winner);
            }
        }
    }

    /**
     * calculate final winner
     */
    function calculate() external onlyOwner {
        require(users.length > 0, "empty users");
        require(winner == address(0), "winner already come up");

        address winner_1;
        uint maxAmount = accounts[users[0]];
        for (uint i = 0; i < users.length; i++) {
            address user = users[i];
            uint amount = accounts[user];
            if (maxAmount <= amount) {
                maxAmount = amount;
                winner_1 = user;
            }
            winner = winner_1;
        }
    }

    /**
     * clear participants
     */
    function clearUser(address addr) internal {
        accounts[addr] = 0;
        for (uint i = 0; i < users.length; i++) {
            address user = users[i];
            if (user == addr) {
                users[i] = users[users.length - 1];
                users.pop();
            }
        }
        delete userExists[addr];
    }
}
