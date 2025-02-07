// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract carinsurance {
    address public owner;
    uint256 public constant PREMIUM_PERCENTAGE = 4;

    struct Policy {
        address policyHolder;
        uint256 carValue;
        uint256 premium;
        bool isActive;
    }

    struct Claim {
        address claimant;
        uint256 amount;
        bool approved;
    }

    mapping(address => Policy) public policies;
    mapping(address => Claim) public claims;

    event PolicyPurchased(address indexed user, uint256 value, uint256 premium);
    event ClaimFiled(address indexed user, uint256 amount);
    event ClaimApproved(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function purchasePolicy() external payable {
        require(msg.value > 0, "Send ETH for premium");

        uint256 carValue = (msg.value * 100) / PREMIUM_PERCENTAGE;
        policies[msg.sender] = Policy(msg.sender, carValue, msg.value, true);

        emit PolicyPurchased(msg.sender, carValue, msg.value);
    }

    function approveClaim(address user, uint256 amount) external {
        require(msg.sender == owner, "Only owner can approve claims");

        claims[user] = Claim(user, amount, true);
        payable(user).transfer(amount);

        emit ClaimApproved(user, amount);
    }

    function fileClaim(uint256 amount) external {
        require(policies[msg.sender].isActive, "No active policy");
        claims[msg.sender] = Claim(msg.sender, amount, false);

        emit ClaimFiled(msg.sender, amount);
    }
}
