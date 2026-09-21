# Case Study — Blockchain-Educational-Credentials

**Repository:** [Blockchain-Educational-Credentials](https://github.com/Freddricklogan/Blockchain-Educational-Credentials) · **Live demo:** none — see the successor, [verifiable-academic-credentials](https://freddricklogan.github.io/verifiable-academic-credentials/) · **Author:** Freddrick Logan

---

## 1. Who has this problem

Registrars who answer verification requests one at a time; employers and admissions offices who wait on them; learners who cannot prove what they earned without asking the institution to vouch for them again. And, closer to home, anyone who has an early design in a public repository that claims more than it does.

## 2. The problem, as a scenario

A hiring manager needs to confirm a degree. They email the registrar, who checks a student information system and replies in a week. The learner, meanwhile, holds a PDF that proves nothing. My first response to that scenario was this repository: a public chain where authorised issuers record a hash of each credential, revoke it if needed, and anyone verifies. I wrote the governance policies, sketched the paper, wrote one contract and one verifier component, and then wrote a README that described the system I intended — proofs, identities, wallets, an API — rather than the one I had.

## 3. What it costs to leave it alone

Two costs. The design cost: a verifier still cannot read the credential from the chain, only confirm that some issuer stored some hash, so the registrar is still in the loop for anything that matters. The honesty cost: a portfolio repository whose README promises zero-knowledge proofs over a 137-line contract with no tests is the kind of thing a careful reader finds in five minutes, and it undermines every other repository beside it.

## 4. The approach, and the alternative I rejected

I rejected finishing the blockchain design. Once I asked what a verifier actually needs — the issuer's public key and a credential the learner can hand over — the ledger had no job left. A signed credential checked locally needs no registry, no gas and no gateway, and it works offline. That became VeriCred, built separately with its own tests and decision records.

I also rejected deleting this repository. The reasoning is worth showing, and the governance templates stand on their own. So the repository is archived in place: the README retracts the claims and says what is here, the audit records what was claimed and what the code does, a link check keeps the Markdown honest, and nothing in the paper, policies, guide or code is altered.

## 5. What the code does today

`src/contracts/EducationalCredential.sol` is unchanged. A governance address authorises and de-authorises issuers. `issueCredential` takes a recipient, an IPFS hash string and an expiry, derives an identifier with `keccak256` over those plus the block timestamp, and stores the record. `revokeCredential` is restricted to the original issuer. `verifyCredential` returns false for an unknown identifier, a revoked credential, a de-authorised issuer or a passed expiry, and true otherwise. `src/web/CredentialVerifier.jsx` is unchanged: it imports an ABI file that is not in the repository, targets a placeholder address, and renders the hash as a gateway link. It has never run.

What was added: a README that describes the repository as found and points to the successor; `AUDIT.md`; `scripts/check_links.py` and a Makefile target that fail on any broken internal Markdown link; a CI workflow that runs the check on every push and pull request and an advisory external link check on `main`.

## 6. Evidence

The internal link check reports 5 references and 0 broken. There are no tests, because there is no runnable code: the contract was never compiled in this repository and the component cannot resolve its imports. The successor has 133 tests; its numbers belong to its own case study. The claims retracted from the old README are listed in the audit with the code that contradicts them.

## 7. What it would take to run this in production

Nothing here should run in production. Someone who wanted the on-chain design would need to compile and test the contract, deploy it, publish the ABI, fix the placeholder address, define a credential schema and bind it to the hash, and validate the gateway link — and would still have a system that cannot show a verifier the credential. The production path is VeriCred.

## 8. Limits and next steps

The paper is an outline with no references and its case-studies section names categories, not cases; it is described as such and left alone. No licence was ever stated for the documents; choosing one is the only change I would still make here. There is no next step for the code.

## 9. Who should look at this

Anyone evaluating VeriCred who wants to see the design it replaced and why, and anyone judging whether I will correct my own overstated repository rather than quietly leave it.
