// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Import OpenZeppelin's Ownable for secure ownership
import "@openzeppelin/contracts/access/Ownable.sol";

contract CarInsurance is Ownable {
    uint256 public constant PREMIUM_PERCENTAGE = 4;
    uint256 public constant MIN_RISK_SCORE = 50;   // 50%
    uint256 public constant MAX_RISK_SCORE = 200;  // 200%

    struct Policy {
        address policyHolder;
        uint256 carValue;
        uint256 premium;
        uint256 riskScore;
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
    event RiskScoreUpdated(address indexed user, uint256 newRiskScore, uint256 newPremium);

    constructor() Ownable(msg.sender) {}

    function purchasePolicy() external payable {
        require(msg.value > 0, "Send ETH for premium");
        require(!policies[msg.sender].isActive, "Active policy already exists");

        uint256 carValue = (msg.value * 100) / PREMIUM_PERCENTAGE;
        policies[msg.sender] = Policy({
            policyHolder: msg.sender,
            carValue: carValue,
            premium: msg.value,
            riskScore: 100, // Initial risk score = 100%
            isActive: true
        });

        emit PolicyPurchased(msg.sender, carValue, msg.value);
    }

    function approveClaim(address user, uint256 amount) external onlyOwner {
        require(policies[user].isActive, "Policy inactive");
        require(claims[user].amount == amount, "Invalid claim amount");

        claims[user].approved = true;
        (bool sent, ) = payable(user).call{value: amount}("");
        require(sent, "Transfer failed");

        emit ClaimApproved(user, amount);
    }

    function fileClaim(uint256 amount) external {
        require(policies[msg.sender].isActive, "No active policy");
        require(claims[msg.sender].amount == 0, "Claim already filed");

        claims[msg.sender] = Claim(msg.sender, amount, false);
        emit ClaimFiled(msg.sender, amount);
    }

    function updateRiskScore(address policyHolder, uint256 newRiskScore) external onlyOwner {
        Policy storage policy = policies[policyHolder];
        require(policy.isActive, "Policy inactive");
        require(newRiskScore >= MIN_RISK_SCORE && newRiskScore <= MAX_RISK_SCORE, "Invalid risk score");

        uint256 oldRiskScore = policy.riskScore;
        policy.premium = (policy.premium * newRiskScore) / oldRiskScore;
        policy.riskScore = newRiskScore;

        emit RiskScoreUpdated(policyHolder, newRiskScore, policy.premium);
    }
}
