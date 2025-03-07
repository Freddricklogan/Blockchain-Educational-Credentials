import React, { useState } from 'react';
import { ethers } from 'ethers';
import EducationalCredential from '../contracts/EducationalCredential.json';

const CredentialVerifier = () => {
  const [credentialId, setCredentialId] = useState('');
  const [verificationResult, setVerificationResult] = useState(null);
  const [credentialDetails, setCredentialDetails] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const contractAddress = '0x1234567890123456789012345678901234567890';

  const verifyCredential = async () => {
    if (!credentialId) {
      setError('Please enter a credential ID');
      return;
    }

    setLoading(true);
    setError('');
    setVerificationResult(null);
    setCredentialDetails(null);

    try {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      const signer = provider.getSigner();
      
      const contract = new ethers.Contract(
        contractAddress,
        EducationalCredential.abi,
        signer
      );

      // Verify the credential
      const isValid = await contract.verifyCredential(credentialId);
      setVerificationResult(isValid);

      // Get credential details if valid
      if (isValid) {
        const details = await contract.getCredential(credentialId);
        setCredentialDetails({
          issuer: details.issuer,
          recipient: details.recipient,
          credentialHash: details.credentialHash,
          issueDate: new Date(details.issueDate.toNumber() * 1000).toLocaleString(),
          expirationDate: details.expirationDate.toNumber() === 0 
            ? 'No Expiration' 
            : new Date(details.expirationDate.toNumber() * 1000).toLocaleString(),
          revoked: details.revoked
        });
      }
    } catch (err) {
      setError('Error verifying credential: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="credential-verifier">
      <h2>Educational Credential Verifier</h2>
      
      <div className="verification-form">
        <input
          type="text"
          placeholder="Enter Credential ID"
          value={credentialId}
          onChange={(e) => setCredentialId(e.target.value)}
        />
        <button onClick={verifyCredential} disabled={loading}>
          {loading ? 'Verifying...' : 'Verify Credential'}
        </button>
      </div>
      
      {error && <div className="error-message">{error}</div>}
      
      {verificationResult !== null && (
        <div className={`verification-result ${verificationResult ? 'valid' : 'invalid'}`}>
          <h3>
            {verificationResult 
              ? '✅ Credential is Valid' 
              : '❌ Credential is Invalid or Revoked'}
          </h3>
        </div>
      )}
      
      {credentialDetails && (
        <div className="credential-details">
          <h3>Credential Details</h3>
          <table>
            <tbody>
              <tr><td>Issuing Institution:</td><td>{credentialDetails.issuer}</td></tr>
              <tr><td>Recipient:</td><td>{credentialDetails.recipient}</td></tr>
              <tr><td>Issue Date:</td><td>{credentialDetails.issueDate}</td></tr>
              <tr><td>Expiration:</td><td>{credentialDetails.expirationDate}</td></tr>
              <tr>
                <td>Document:</td>
                <td>
                  <a href={`https://ipfs.io/ipfs/${credentialDetails.credentialHash}`} target="_blank" rel="noopener noreferrer">
                    View Original Credential
                  </a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};

export default CredentialVerifier;
