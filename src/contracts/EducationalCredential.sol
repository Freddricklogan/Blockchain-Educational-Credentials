// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Educational Credential Smart Contract
 * @dev Manages issuance and verification of educational credentials
 */
contract EducationalCredential {
    // Credential structure
    struct Credential {
        address issuer;
        address recipient;
        string credentialHash;  // IPFS hash of full credential
        uint256 issueDate;
        uint256 expirationDate; // 0 if no expiration
        bool revoked;
    }
    
    // Storage mappings
    mapping(bytes32 => Credential) public credentials;
    mapping(address => bool) public authorizedIssuers;
    
    // Contract governance
    address public governanceAuthority;
    
    // Events
    event CredentialIssued(bytes32 indexed credentialId, address indexed issuer, address indexed recipient);
    event CredentialRevoked(bytes32 indexed credentialId, address indexed issuer);
    event IssuerAuthorized(address indexed issuer);
    event IssuerRevoked(address indexed issuer);
    
    // Modifiers
    modifier onlyGovernance() {
        require(msg.sender == governanceAuthority, "Only governance can call this function");
        _;
    }
    
    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Only authorized issuers can call this function");
        _;
    }
    
    constructor() {
        governanceAuthority = msg.sender;
    }
    
    /**
     * @dev Authorize an educational institution to issue credentials
     */
    function authorizeIssuer(address issuer) external onlyGovernance {
        authorizedIssuers[issuer] = true;
        emit IssuerAuthorized(issuer);
    }
    
    /**
     * @dev Issue a new educational credential
     * @return credentialId Unique identifier for the credential
     */
    function issueCredential(
        address recipient,
        string calldata credentialHash,
        uint256 expirationDate
    ) 
        external 
        onlyAuthorizedIssuer 
        returns (bytes32)
    {
        bytes32 credentialId = keccak256(
            abi.encodePacked(msg.sender, recipient, credentialHash, block.timestamp)
        );
        
        require(credentials[credentialId].issuer == address(0), "Credential ID already exists");
        
        credentials[credentialId] = Credential({
            issuer: msg.sender,
            recipient: recipient,
            credentialHash: credentialHash,
            issueDate: block.timestamp,
            expirationDate: expirationDate,
            revoked: false
        });
        
        emit CredentialIssued(credentialId, msg.sender, recipient);
        return credentialId;
    }
    
    /**
     * @dev Revoke a previously issued credential
     */
    function revokeCredential(bytes32 credentialId) external {
        Credential storage credential = credentials[credentialId];
        require(credential.issuer == msg.sender, "Only original issuer can revoke");
        require(!credential.revoked, "Credential already revoked");
        
        credential.revoked = true;
        emit CredentialRevoked(credentialId, msg.sender);
    }
    
    /**
     * @dev Verify a credential's validity
     */
    function verifyCredential(bytes32 credentialId) external view returns (bool) {
        Credential memory credential = credentials[credentialId];
        
        if (credential.issuer == address(0) || credential.revoked || !authorizedIssuers[credential.issuer]) {
            return false;
        }
        
        if (credential.expirationDate != 0 && block.timestamp > credential.expirationDate) {
            return false;
        }
        
        return true;
    }
    
    /**
     * @dev Get credential details
     */
    function getCredential(bytes32 credentialId) external view returns (
        address issuer,
        address recipient,
        string memory credentialHash,
        uint256 issueDate,
        uint256 expirationDate,
        bool revoked
    ) {
        Credential memory credential = credentials[credentialId];
        return (
            credential.issuer,
            credential.recipient,
            credential.credentialHash,
            credential.issueDate,
            credential.expirationDate,
            credential.revoked
        );
    }
}
