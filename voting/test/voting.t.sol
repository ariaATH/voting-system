// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "../contracts/voting.sol";

contract votingTest is Test {
    voting public votingContract;
    address public voter1 = address(0x1);
    address public voter2 = address(0x2);
    address public proposlowner = address(0x3);

    function setUp() public {
        votingContract = new voting();
    }

    function testCreateproposal() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 1", "Description for Proposal 1", block.timestamp, block.timestamp + 1 days, ProposalStatus.Public_proposal);
        (string memory name, string memory description, uint256 voteCount, uint256 starttime, uint256 endtime, address owner, ProposalStatus status) = votingContract.getProposal(1);
        assertEq(name, "Proposal 1");
        assertEq(description, "Description for Proposal 1");
        assertEq(voteCount, 0);
        assertEq(starttime, block.timestamp);
        assertEq(endtime, block.timestamp + 1 days);
        assertEq(owner, proposlowner);
        assertEq(uint(status), uint(ProposalStatus.Public_proposal));
    }

    function testRegisterVoters() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 2", "Description for Proposal 2", block.timestamp, block.timestamp + 1 days, ProposalStatus.Private_proposal);
        vm.prank(proposlowner);
        votingContract.registerVoters(voter1, 1);
        vm.prank(proposlowner);
        votingContract.registerVoters(voter2, 1);
        // No direct way to check registration status, but we can attempt to vote and expect it to succeed for registered voters
        vm.prank(voter1);
        votingContract.vote(1);
        vm.prank(voter2);
        votingContract.vote(1);
    }

    function testVote() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 3", "Description for Proposal 3", block.timestamp, block.timestamp + 1 days, ProposalStatus.Public_proposal);
        vm.prank(voter1);
        votingContract.vote(1);
        ( , , uint256 voteCount, , , , ) = votingContract.getProposal(1);
        assertEq(voteCount, 1);
    }

    function testVotePrivateProposal() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 4", "Description for Proposal 4", block.timestamp, block.timestamp + 1 days, ProposalStatus.Private_proposal);
        vm.prank(proposlowner);
        votingContract.registerVoters(voter1, 1);
        vm.prank(voter1);
        votingContract.vote(1);
        ( , , uint256 voteCount, , , , ) = votingContract.getProposal(1);
        assertEq(voteCount, 1);
    }

    function testVoteWithoutRegistration() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 5", "Description for Proposal 5", block.timestamp, block.timestamp + 1 days, ProposalStatus.Private_proposal);
        vm.prank(voter1);
        vm.expectRevert("Voter is not registered for this private proposal");
        votingContract.vote(1);
    }

    function testVoteAfterEndTime() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 6", "Description for Proposal 6", block.timestamp, block.timestamp + 1 days, ProposalStatus.Public_proposal);
        vm.warp(block.timestamp + 2 days);
        vm.prank(voter1);
        vm.expectRevert("Proposal is not active");
        votingContract.vote(1);
    }

    function testVoteTwice() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 7", "Description for Proposal 7", block.timestamp, block.timestamp + 1 days, ProposalStatus.Public_proposal);
        vm.prank(voter1);
        votingContract.vote(1);
        vm.prank(voter1);
        vm.expectRevert("you voted for this proposal");
        votingContract.vote(1);
    }

    function testInvalidProposalTimes() public {
        vm.prank(proposlowner);
        vm.expectRevert("Start time must be before end time");
        votingContract.createProposal("Proposal 8", "Description for Proposal 8", block.timestamp + 1 days, block.timestamp, ProposalStatus.Public_proposal);
    }

    function testOnlyOwnerCanRegisterVoters() public {
        vm.prank(proposlowner);
        votingContract.createProposal("Proposal 9", "Description for Proposal 9", block.timestamp, block.timestamp + 1 days, ProposalStatus.Private_proposal);
        vm.prank(voter1);
        vm.expectRevert("Only proposal owner can register voters");
        votingContract.registerVoters(voter2, 1);
    }
}