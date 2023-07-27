// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Wakama {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
}

mapping(uint256 => Campaign) public campaigns;

uint256 public number0fCampaigns = 0;

function createCampaign (address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) 
{
    Campaign storage campaign = campaigns [number0fCampaigns];
    
 
    require (campaign.deadline < block.timestamp, "The deadline should be a date in the futur.");

   campaign.owner = _owner;
   campaign.title = _title;
   campaign.description = _description;
   campaign.target = _target;
   campaign.deadline = _deadline;
   campaign.amountCollected = 0;
   campaign.image = _image;

   number0fCampaigns++;

   return number0fCampaigns -1;

}
function donateToCampaing (uint256 _id) public payable {
    uint256 amount = msg.value;
    Campaign storage campaign = campaigns[_id];
    campaign.donators.push(msg.sender);
    campaign.donations.push(amount);

    (bool sent,) = payable(campaign.owner).call{value: amount}("");

    if(sent) {
        campaign.amountCollected = campaign.amountCollected + amount;
    }
}
function getDonators (uint256 _id) view public returns (address[] memory, uint256[] memory) {
    return (campaigns[_id].donators, campaigns[_id].donations);
}
function getCampaigns () public view returns (Campaign[] memory) {
    Campaign[] memory allCampaings = new Campaign[](number0fCampaigns);

    for(uint i = 0; i < number0fCampaigns; i++){
        Campaign storage item = campaigns[i];

        allCampaings[i] = item;
    }

    return allCampaings;
}
}