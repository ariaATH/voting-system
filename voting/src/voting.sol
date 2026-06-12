// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

enum ProposalStatus { Public_proposal, Private_proposal }

contract voting {

    // Define a struct to represent a proposal
    struct Proposal {
        string name;
        string description;
        uint256 voteCount;
        uint256 starttime;
        uint256 endtime;
        address owner;
        ProposalStatus status;
    }

    // Define a struct to represent a voter
    struct Voter {
        mapping(uint256 => bool) registredProposals; // Mapping of proposal ID to registration status for private proposals
        mapping(uint256 => bool) hasVoted; // Mapping of proposal ID to voting status
    }

    mapping(uint256 => Proposal) public proposals; // Mapping of proposal ID to Proposal struct
    mapping(address => Voter) private voters; // Mapping of voter address to Voter struct (made private because Voter contains mappings)
    uint256 public proposalCount; // Counter for proposal IDs

    // Define events for proposal creation, voting, and voter registration
    event ProposalCreated(uint256 proposalId, string name, string description, uint256 starttime, uint256 endtime);
    event Voted(address voter, uint256 proposalId);
    event VoterRegistered(address voter, uint256 proposalId);

    // Define custom errors for better error handling
    error ProposalNotActive();
    error VoterNotRegistered();
    error VoterAlreadyVoted();

    // Function to create a new proposal
    function createProposal(string memory _name, string memory _description, uint256 _starttime, uint256 _endtime , ProposalStatus _status) public {
        require(_starttime < _endtime, "Start time must be before end time");
        proposalCount++;
        proposals[proposalCount] = Proposal(_name, _description, 0, _starttime, _endtime, msg.sender, _status);
        emit ProposalCreated(proposalCount, _name, _description, _starttime, _endtime);
    }

    // Function to register voters for a private proposal
    function registerVoters(address _voter , uint256 _proposalId) public {
        require(proposals[_proposalId].status != ProposalStatus.Public_proposal, "Proposal is public");
        require(proposals[_proposalId].owner == msg.sender, "Only proposal owner can register voters");
        voters[_voter].registredProposals[_proposalId] = true;
        emit VoterRegistered(_voter, _proposalId);
    }

    // Function to vote on a proposal
    function vote(uint256 _proposalId) public {
        require(!voters[msg.sender].hasVoted[_proposalId] , "you voted for this proposal");
        require(block.timestamp >= proposals[_proposalId].starttime && block.timestamp <= proposals[_proposalId].endtime, "Proposal is not active");
        if(proposals[_proposalId].status == ProposalStatus.Private_proposal) {
            require(voters[msg.sender].registredProposals[_proposalId], "Voter is not registered for this private proposal");
            proposals[_proposalId].voteCount++;
            voters[msg.sender].hasVoted[_proposalId] = true;
            emit Voted(msg.sender, _proposalId);
        }

        else {
        proposals[_proposalId].voteCount++;
        voters[msg.sender].hasVoted[_proposalId] = true;
        emit Voted(msg.sender, _proposalId);
        }

    }

    // View functions to retrieve proposal and voter information
    function getProposal(uint256 _proposalId) public view returns (string memory name, string memory description, uint256 voteCount, uint256 starttime, uint256 endtime, address owner, ProposalStatus status) {
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.name, proposal.description, proposal.voteCount, proposal.starttime, proposal.endtime, proposal.owner, proposal.status);
    }
    // Additional view functions to retrieve specific information about proposals and voters
    function getVoteCount(uint256 _proposalId) public view returns (uint256) {
        return proposals[_proposalId].voteCount;
    }

    // Function to check if a voter is registered for a specific proposal
    function isVoterRegistered(address _voter, uint256 _proposalId) public view returns (bool) {
        return voters[_voter].registredProposals[_proposalId];
    }

    // Function to check if a voter has already voted on a specific proposal
    function hasVoterVoted(address _voter, uint256 _proposalId) public view returns (bool) {
        return voters[_voter].hasVoted[_proposalId];
    }

    // Function to get the status of a proposal
    function getProposalStatus(uint256 _proposalId) public view returns (ProposalStatus) {
        return proposals[_proposalId].status;
    }

    // Function to get the owner of a proposal
    function getProposalOwner(uint256 _proposalId) public view returns (address) {
        return proposals[_proposalId].owner;
    }

    // Function to get the start and end time of a proposal
    function getProposalTime(uint256 _proposalId) public view returns (uint256 starttime, uint256 endtime) {
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.starttime, proposal.endtime);
    }

    // Function to get the description and name of a proposal
    function getProposalDescription(uint256 _proposalId) public view returns (string memory) {
        return proposals[_proposalId].description;
    }

    // Function to get the name of a proposal
    function getProposalName(uint256 _proposalId) public view returns (string memory) {
        return proposals[_proposalId].name;
    }

}