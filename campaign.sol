// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CampaignManager is Ownable {

    struct Campaign {
       
        string name;
        string cause;
        uint256 expReward;
        uint256 startTime;
        uint256 endTime;
        address creator;
        bool exists;  
    }

    struct Level {
        uint256 expRequired;
        uint256 nftId;
    }

    mapping(address => uint256) public playerExp;
    mapping(address => uint256) public playerLevel;
    mapping(address => mapping(uint256 => bool)) public campaignParticipation;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => Level) public levels;

    uint256 public nextCampaignId = 1;
    uint256 public nextLevelId = 1;

    //events to be executed
    event CampaignCreated(uint256 campaignId, string name, string cause, uint256 expReward, uint256 startTime, uint256 endTime);
    event PlayerParticipated(address indexed player, uint256 campaignId, uint256 expReward);
    event PlayerLeveledUp(address indexed player, uint256 newLevel);
    event NFTMinted(address indexed player, uint256 level, uint256 nftId);

    
    // Ensure only campaign creators can create campaigns
    modifier onlyCreator() {
        require(msg.sender == owner(), "Only the creator can perform this action");
        _;
    }

    // Ensure player has enough EXP to mint the NFT
    modifier onlyEligibleLevel(uint256 levelId) {
        require(playerLevel[msg.sender] >= levelId, "Not eligible for this NFT");
        _;
    }

    // Pass msg.sender to the Ownable constructor(so that only owner can make changes)
    constructor() Ownable(msg.sender) {}

    // developer function to decide nft and experience required
    function defineLevel(uint256 expRequired, uint256 nftId) external onlyOwner {
        levels[nextLevelId] = Level(expRequired, nftId);
        nextLevelId++;
    }

    //creator work
   
    uint256 public campaignCount;
    // Function to create a campaign 
    function createCampaign(
        string memory _name,
        string memory _cause,
        uint256 _expReward,
        uint256 _startTime,
        uint256 _endTime
    ) public {
        campaigns[campaignCount] = Campaign({
            name: _name,
            cause: _cause,
            expReward: _expReward,
            startTime: _startTime,
            endTime: _endTime,
            creator: msg.sender,
            exists: true
        });
        campaignCount++;
    }

    // function to get all ongoing campaign IDs
    function getOngoingCampaigns() public view returns (uint256[] memory) {
        uint256 ongoingCount = 0;

        // first pass: Count how many campaigns are ongoing to size the array correctly
        for (uint256 i = 0; i < campaignCount; i++) {
            if (block.timestamp >= campaigns[i].startTime && block.timestamp <= campaigns[i].endTime) {
                ongoingCount++;
            }
        }

        // create an array to store the IDs of ongoing campaigns
        uint256[] memory ongoingCampaigns = new uint256[](ongoingCount);
        uint256 index = 0;

        // second pass: Collect the IDs of ongoing campaigns
        for (uint256 i = 0; i < campaignCount; i++) {
            if (block.timestamp >= campaigns[i].startTime && block.timestamp <= campaigns[i].endTime) {
                ongoingCampaigns[index] = i;
                index++;
            }
        }

        return ongoingCampaigns;
    }
    
     // what players can do 
    function participateInCampaign(uint256 campaignId) external {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp >= campaign.startTime && block.timestamp <= campaign.endTime, "Campaign not active");
        require(!campaignParticipation[msg.sender][campaignId], "Already participated in this campaign");

        campaignParticipation[msg.sender][campaignId] = true;
        playerExp[msg.sender] += campaign.expReward;

        // update player level
        uint256 newLevel = getLevelFromExp(playerExp[msg.sender]);
        if (newLevel > playerLevel[msg.sender]) {
            playerLevel[msg.sender] = newLevel;
            emit PlayerLeveledUp(msg.sender, newLevel); // emit event for level-up
        }

        emit PlayerParticipated(msg.sender, campaignId, campaign.expReward); // emit event for EXP gain
    }

    function mintNFT(uint256 levelId) external onlyEligibleLevel(levelId) {
        Level storage level = levels[levelId];
        require(level.nftId != 0, "Level not defined");

        // mint the NFT for the player
        // placeholder 
        emit NFTMinted(msg.sender, levelId, level.nftId);
    }

    //to view details of player
    function getLevelFromExp(uint256 exp) public view returns (uint256) {
        for (uint256 i = 1; i <= nextLevelId; i++) {
            if (exp < levels[i].expRequired) {
                return i - 1;
            }
        }
        return nextLevelId - 1;
    }

    function viewCampaigns() external view returns (Campaign[] memory) {
        Campaign[] memory activeCampaigns = new Campaign[](nextCampaignId - 1);
        uint256 counter = 0;
        for (uint256 i = 1; i < nextCampaignId; i++) {
            if (campaigns[i].exists) {
                activeCampaigns[counter] = campaigns[i];
                counter++;
            }
        }
        return activeCampaigns;
    }

    function getPlayerInfo(address player) external view returns (uint256 exp, uint256 level) {
        exp = playerExp[player];
        level = playerLevel[player];
    }
}

//contract address deployed on sepolia testnet
//0x808EdCf3F03AcA7d4fAF2ff084f1623952C7CF59





















