# AUDIT — Blockchain-Educational-Credentials (archived concept)

Audit of the repository as it stood: a README, a paper outline
(59 lines), a governance framework and an issuance-policy template,
an implementation guide, one Solidity contract (137 lines) and one
React component (114 lines). No tests, no build, no deployment, no
workflow. The README linked to a lowercase Pages URL served by a
stale folder in the user-site repository.

The repository is kept as the record of the concept that became
[verifiable-academic-credentials](https://github.com/Freddricklogan/verifiable-academic-credentials)
(VeriCred). Nothing here is developed further.

---

## A. Claims the repository could not support

### A1 — "A comprehensive blockchain solution"
The README described secure issuance, self-sovereign identity, instant
verification, zero-knowledge proofs for selective disclosure, DIDs, a
student wallet, an administrative portal and a verification API. The
code is one contract with issue / revoke / verify functions keyed on an
IPFS hash string, and one component that calls it. There are no
proofs, no DIDs, no wallet, no portal, no API. **Fix:** the README
now describes what is here and points to the successor.

### A2 — A paper with no references
`paper/README.md` lists "8. References" in its table of contents; the
section does not exist. Sections 3–6 are bullet outlines, and "Case
Studies" names four categories with no cases. **Fix:** left as it is
and described as an outline, not a paper.

## B. Code, as found

### B1 — Contract
`src/contracts/EducationalCredential.sol`: a governance address
authorises issuers; `issueCredential` stores issuer, recipient, an
IPFS hash string, issue and expiry timestamps under a `keccak256` of
those inputs plus `block.timestamp`; `verifyCredential` returns false
for unknown, revoked, de-authorised-issuer or expired credentials.
Unpinned `pragma ^0.8.0`, no tests, never deployed. The credential
content lives off-chain at the hash; nothing binds the hash to a
schema or to the recipient's identity.

### B2 — Verifier component
`src/web/CredentialVerifier.jsx` imports an ABI file
(`../contracts/EducationalCredential.json`) that is not in the
repository, calls the contract at the placeholder address
`0x1234567890123456789012345678901234567890`, and renders the stored
hash as an `ipfs.io` gateway link without validating it. It cannot
have run.

### B3 — Why the successor is registry-free
VeriCred keeps the learner-owned, offline-verifiable goal and drops
the chain: a signed credential the verifier checks locally needs no
registry, no gas and no gateway. That decision is documented in
VeriCred's own ADRs; this repository is the "before".

## C. What was added

| Item | Where |
| --- | --- |
| Archive banner and honest description | `README.md` |
| Internal Markdown link check | `scripts/check_links.py`, `Makefile` (`make check`) |
| CI (link check) + advisory external link check | `.github/workflows/deploy.yml` |
| Case study | `docs/CASE_STUDY.md` |

Nothing in `paper/`, `policy/`, `documentation/` or `src/` was
changed.
