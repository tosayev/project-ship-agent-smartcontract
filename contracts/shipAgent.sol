// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract shipAgent {
    // Declare state variables at contract level.  These variables
    // will be stored on the blockchain and cost gas therefore should only
    // be the most critical variables required to execute the contract.
    address public agencyOwner; // need to know who owns the agency.  Only the Agency Owner can change the name of the agency
    string public agencyName; // need to uniqely identify the ship with IMO number
    string public shipIMONumber; // need to uniqely identify the ship with IMO number
    string public shipNetTonnage; // need to identify ship's net tonnage
    mapping (address => uint256) public shipAccountBalance; // create mapping


    //constructor will only run once, when the contract is deployed
    constructor() {
        // We're setting the Agency Owner to the Ethereum address that deploys
        // the contract.  msg.sender is a global variable that stores the address
        // of the account that initiates the transaction.
        agencyOwner = msg.sender;
    }
    
    function setAgencyName(string memory _name) external {
        // This function sets the IMO number of the ship.  Only the Agency Owner can set the name of the agency.
        require(msg.sender == agencyOwner, "You must be the owner to set the name of the agency.");
        agencyName = _name;
    }

    function setShipNetTonnage(string memory _shipNetTonnage) external {
        // This function sets the Net Tonnage of the ship.  Anyone can set the IMO number of the ship.
        shipNetTonnage = _shipNetTonnage;
    }

    function setShipIMONumber(string memory _shipIMONumber) external {
        // This function sets the IMO number of the ship.  Anyone can set the IMO number of the ship.
        shipIMONumber = _shipIMONumber;
    }

    function depositMoney() public payable {
        // This function allows the Ship Operator to deposit funds into the ship's account with the agent
        // which practically means paying the DA.  The amount needs to be >0.
        require(msg.value != 0, "You need to deposit some amount of money!");
        shipAccountBalance[msg.sender] += msg.value;
    }  
        
    function withdrawMoney(address payable _to, uint256 _total) public {
        // This function allows the Ship Operator to withdraw funds from the ship's account with the agent.
        // The amount must be <=shipAccountBalance.
        require(_total <= shipAccountBalance[msg.sender], "You have insufficient funds to withdraw.");
        shipAccountBalance[msg.sender] -= _total;
        _to.transfer(_total);
    }

    function payDues(uint256 _dues) public {
        // After depositing sufficient funds in the ship's account with the agent, the Ship Operator can
        // request transit clearance.  For clearance, the required dues needs to be subtracted from the ship's
        // balance and sent to the Agency Owner.
        shipAccountBalance[msg.sender] -= _dues;
    }

    function getShipAccountBalance() external view returns (uint256) {
        // This function returns the ship's balance with the agent.
        return shipAccountBalance[msg.sender];
    }
    
    function getAgencyBalance() public view returns (uint256) {
        // We want only the agency owner to see all balances.
        require(msg.sender == agencyOwner, "You must be the owner of the agency to see all balances.");
        return address(this).balance;
    }
}