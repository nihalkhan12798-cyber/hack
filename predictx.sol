// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NexTradePrediction {
    struct Market {
        string question;
        uint256 totalYesPool;
        uint256 totalNoPool;
        bool isResolved;
        bool outcomeYes;
    }

    mapping(uint256 => Market) public markets;
    uint256 public marketCount;
    
    // Tracks user stakes: user => marketId => isYes => amount
    mapping(address => mapping(uint256 => mapping(bool => uint256))) public stakes;

    event MarketCreated(uint256 marketId, string question);
    event StakePlaced(uint256 marketId, address user, bool isYes, uint256 amount);

    // Initializing the demo markets for the hackathon
    constructor() {
        createMarket("Will Shardeum Mainnet launch in 2026?");
        createMarket("Will US Fed cut rates impacting INR by Q3?");
        createMarket("Will India-US cross-border SaaS revenue exceed $10B?");
    }

    function createMarket(string memory _question) public {
        markets[marketCount] = Market(_question, 0, 0, false, false);
        emit MarketCreated(marketCount, _question);
        marketCount++;
    }

    function placeTrade(uint256 _marketId, bool _isYes) external payable {
        require(_marketId < marketCount, "Invalid Market");
        require(!markets[_marketId].isResolved, "Market already resolved");
        require(msg.value > 0, "Must stake Shardeum tokens (SHD)");

        if (_isYes) {
            markets[_marketId].totalYesPool += msg.value;
        } else {
            markets[_marketId].totalNoPool += msg.value;
        }

        stakes[msg.sender][_marketId][_isYes] += msg.value;
        emit StakePlaced(_marketId, msg.sender, _isYes, msg.value);
    }
}
