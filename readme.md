# CampaignManager Smart Contract

## Overview

`CampaignManager` is a smart contract that allows developers to create campaigns, track player participation, experience points (EXP), and allow players to mint NFTs based on their progress through defined experience levels. The system supports dynamic campaign creation by creators and offers NFT minting based on player level progression.

## Features

- **Campaign Creation**: Campaign creators can define campaigns that reward players with EXP.
- **Player Participation**: Players can join campaigns to earn EXP, which helps them level up.
- **EXP & Level System**: Players progress through levels based on the EXP they earn.
- **NFT Minting**: Players can mint NFTs associated with specific levels once they reach the required EXP.
- **Campaign Management**: Players can view ongoing campaigns and participate in active ones.

---

## Contract Roles

### Developer (Owner)
- Defines the overall level system.
- Specifies the EXP required to reach each level and assigns NFTs to each level.

### Campaign Creators
- Create and manage campaigns for players to participate in.
- Define the name, cause, EXP reward, and the start/end times for campaigns.

### Players
- Participate in campaigns to earn EXP.
- Progress through levels and mint NFTs when eligible based on their current level.

---



## Deployment
The contract has been deployed on the Sepolia testnet.
Contract Address: 0x808EdCf3F03AcA7d4fAF2ff084f1623952C7CF59

