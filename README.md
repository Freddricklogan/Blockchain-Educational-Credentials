# Blockchain-Educational-Credentials: the concept that became VeriCred — a paper outline, governance templates and a single Solidity contract, kept as the record of a design I later replaced

> **Archived concept.** This repository is not developed further. The
> working, tested implementation of learner-owned, offline-verifiable
> academic credentials is
> **[verifiable-academic-credentials](https://github.com/Freddricklogan/verifiable-academic-credentials)**
> (VeriCred, [live demo](https://freddricklogan.github.io/verifiable-academic-credentials/)),
> which keeps the goal and drops the blockchain. Read
> [AUDIT.md](AUDIT.md) for what this repository actually contains and
> why the successor is registry-free.

[![CI/CD](https://github.com/Freddricklogan/Blockchain-Educational-Credentials/actions/workflows/deploy.yml/badge.svg)](https://github.com/Freddricklogan/Blockchain-Educational-Credentials/actions/workflows/deploy.yml)
[![Status archived concept](https://img.shields.io/badge/status-archived%20concept-lightgrey)](#1-executive-summary--business-impact)
[![Successor VeriCred](https://img.shields.io/badge/successor-VeriCred-brightgreen)](https://github.com/Freddricklogan/verifiable-academic-credentials)

## 1. Executive Summary & Business Impact

**Problem statement.** Verifying an academic credential still means
asking the issuing registrar. Learners do not hold anything a third
party can check on its own; institutions carry the verification load
and the fraud risk. This repository is my first written answer to
that problem: put a hash of each credential on a public chain, let
authorised issuers write and revoke, and let anyone verify.

**What is here.** A paper outline on implementation strategy and
governance, a governance framework and a credential-issuance policy
template, an implementation guide, and a proof-of-concept Solidity
contract with a React verifier. It was never deployed or tested, and
the README that came with it described features — zero-knowledge
proofs, DIDs, a wallet, a verification API — that were never built.
That description is gone; the audit records what was claimed.

**Why it was replaced.** The chain solved the wrong half of the
problem. A verifier does not need a global ledger to check a
signature; it needs the issuer's public key and a credential the
learner can hand over. VeriCred does that in the browser, offline,
with 133 tests behind it. This repository is kept so the reasoning is
visible.

**Who it is for.** Anyone comparing the two designs, and anyone
who wants the governance templates, which stand on their own.

**[→ Read the full case study](docs/CASE_STUDY.md)**

## 2. Demonstrated Competencies & Technical Skills

| Area | What the repository shows |
| --- | --- |
| Credential governance | An issuance policy with registrar, department and IT responsibilities; a governance framework covering standards, privacy and institutional control |
| Solidity fundamentals | Issuer authorisation, keyed issuance, revocation and time-bounded verification in a single contract |
| Design judgement | Recognising that the ledger was unnecessary, and replacing the design rather than defending it |
| Honest archiving | Claims retracted, code described as found, successor linked |

## 3. System Architecture & Data Flow

```
paper/README.md                  outline: strategy and governance (no references section)
policy/                          governance framework; issuance-policy template
documentation/                   implementation guide (phased roadmap, security, integration)
src/contracts/EducationalCredential.sol
   governanceAuthority ──authorizeIssuer──► authorizedIssuers
   issuer ──issueCredential(recipient, ipfsHash, expiry)──► credentials[keccak256(...)]
   anyone ──verifyCredential(id)──► false if unknown / revoked / issuer de-authorised / expired
src/web/CredentialVerifier.jsx   ethers.js call to a placeholder address; ABI file not present
```

## 4. Technical Highlights & Engineering Decisions

- **What the contract gets right.** Verification fails closed on four
  conditions, revocation is issuer-only, and issuer authorisation is
  separable from issuance — the governance split the policy template
  describes.
- **What it leaves open.** The credential's content lives off-chain
  at an unvalidated IPFS hash; nothing binds the hash to a schema or
  to the recipient's identity, so a "verified" credential says only
  that some issuer once stored some hash.
- **The decision.** Those gaps are why the successor signs the
  credential itself and verifies locally — see VeriCred's ADRs.
- **Kept as found.** The paper, policies, guide and code are
  unchanged; only the README, the audit, a link check and CI were
  added.

## 5. Getting Started & Verification

There is nothing to run. The contract has no tests and no deployment
script; the verifier component references an ABI that is not in the
repository.

```bash
git clone https://github.com/Freddricklogan/Blockchain-Educational-Credentials.git
cd Blockchain-Educational-Credentials
make check          # internal Markdown link check (3 references, 0 broken)
```

**Verification — the numbers this repository actually produced:**

| Check | Result |
| --- | --- |
| Internal Markdown links | **3 references, 0 broken** |
| Tests | none — no runnable code; see [VeriCred](https://github.com/Freddricklogan/verifiable-academic-credentials) for the tested implementation |

## 6. Live Demo & Production Showcase

No live demo. The successor's demo is at
**<https://freddricklogan.github.io/verifiable-academic-credentials/>**.

---

## License

The contract carries an MIT SPDX header. No licence was stated for the
documents; they remain the author's, all rights reserved, until one is
chosen.
