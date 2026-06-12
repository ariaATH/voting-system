# Voting System

A Solidity smart contract for creating and managing proposals with on-chain voting, built and tested with Foundry.

## What it does

The contract lets anyone create a proposal with a name, description, and a start/end time window. Each proposal is either public or private:

- **Public proposals** — any address can vote during the active time window.
- **Private proposals** — only addresses registered by the proposal owner can vote.

Votes are tracked per address per proposal, so the same wallet can't vote twice on the same proposal.

## Contract overview (`src/voting.sol`)

- `createProposal(...)` — creates a new proposal, validates that the start time is before the end time, and emits `ProposalCreated`.
- `registerVoters(...)` — owner-only, used to whitelist voters for a private proposal. Emits `VoterRegistered`.
- `vote(proposalId)` — casts a vote if the proposal is active, the caller hasn't voted yet, and (for private proposals) the caller is registered. Emits `Voted`.
- A set of view functions (`getProposal`, `getVoteCount`, `isVoterRegistered`, `hasVoterVoted`, `getProposalStatus`, `getProposalOwner`, `getProposalTime`, `getProposalName`, `getProposalDescription`) for reading proposal and voter data.

## Tech stack

- Solidity ^0.8.0
- [Foundry](https://book.getfoundry.sh/) for building, testing, and formatting
- GitHub Actions for CI (build, format check, and tests on every push/PR)

## Getting started

```bash
git clone https://github.com/<your-username>/voting-system.git
cd voting-system/voting
forge build
forge test
```

## Possible next steps

- Add the ability for an owner to close or edit a proposal before it starts
- Switch some `require` statements over to the custom errors already defined in the contract
- Add more tests around edge cases (voting right at `starttime`/`endtime`, double registration, etc.)

## License

MIT
