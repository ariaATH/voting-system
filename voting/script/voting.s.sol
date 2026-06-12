// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/script.sol";
import "../contracts/voting.sol";

contract votingScript is Script {
    function run() public {
        vm.startBroadcast();
        voting votingContract = new voting();
        votingContract.createProposal("Proposal 1", "Description for Proposal 1", block.timestamp, block.timestamp + 1 days, ProposalStatus.Public_proposal);
        votingContract.createProposal("Proposal 2", "Description for Proposal 2", block.timestamp, block.timestamp + 1 days, ProposalStatus.Private_proposal);
        vm.stopBroadcast();
    }
}