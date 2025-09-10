// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {UserType} from "../config/enum.sol";
import {IAdminAction, ICredentialManager, IVerifier, IUserRole} from "../interface/IHealthcareInterface.sol";
import {HealthCareEvent} from "../events/events.sol";
contract HealthcarePlatform is IAdminAction, ICredentialManager, IVerifier, IUserRole, HealthCareEvent {
   

    address public owner;
    mapping(address => bool) public admins;

    mapping(address => UserType) public practitionerRoles;
    mapping(address => uint256) public practitionerToTokenId;
    mapping(uint256 => address) public tokenIdToPractitioner;
    mapping(uint256 => string) public tokenIdToUri;
    mapping(uint256 => uint256) public tokenIdToExpiry;

    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    uint256 public nextTokenId = 1;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Not admin");
        _;
    }

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }

    function addAdmin(address admin) external onlyOwner {
        admins[admin] = true;
    }

    function removeAdmin(address adminToremove) external onlyOwner {
        admins[adminToremove] = false;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        owner = newOwner;
        admins[newOwner] = true;
    }

    function assignRole(address user, UserType role) external onlyAdmin {
        practitionerRoles[user] = role;
    }

    function getRole(address user) external view returns (UserType) {
        return practitionerRoles[user];
    }

    function revokeRole(address user) external onlyAdmin {
        practitionerRoles[user] = UserType.None;
    }

    function registerPractitionerMetadata(address practitioner, string memory uri, uint256 validUntil) external onlyAdmin {
        require(practitioner != address(0), "Invalid address");
        require(practitionerToTokenId[practitioner] == 0, "Already registered");
        uint256 tokenId = nextTokenId++;
        practitionerToTokenId[practitioner] = tokenId;
        tokenIdToPractitioner[tokenId] = practitioner;
        tokenIdToUri[tokenId] = uri;
        tokenIdToExpiry[tokenId] = validUntil;
        emit URI(uri, tokenId);
    }

    function issueNftCredentialToPractitioner(address practitioner) external onlyAdmin {
        uint256 tokenId = practitionerToTokenId[practitioner];
        require(tokenId != 0, "Not registered");
        require(_balances[tokenId][practitioner] == 0, "Already issued");
        _balances[tokenId][practitioner] = 1;
        emit TransferSingle(msg.sender, address(0), practitioner, tokenId, 1);
    }

    function revokeNftCredentialFromPractitioner(address practitioner) external onlyAdmin {
        uint256 tokenId = practitionerToTokenId[practitioner];
        require(tokenId != 0, "Not registered");
        require(_balances[tokenId][practitioner] == 1, "No credential");
        _balances[tokenId][practitioner] = 0;
        emit TransferSingle(msg.sender, practitioner, address(0), tokenId, 1);
    }

    function renewNftCredentialForPractitioner(address practitioner) external onlyAdmin {
        
        uint256 tokenId = practitionerToTokenId[practitioner];
        require(tokenId != 0, "Not registered");
        require(_balances[tokenId][practitioner] == 1, "No credential");
        tokenIdToExpiry[tokenId] = block.timestamp + 365 days;
    }

    function isValidCredential(address practitioner, uint256 tokenId) external view returns (bool) {
        return _balances[tokenId][practitioner] == 1 && block.timestamp < tokenIdToExpiry[tokenId];
    }

    function isRole(address practitioner, uint256 tokenId) external view returns (bool) {
        return tokenIdToPractitioner[tokenId] == practitioner && practitionerRoles[practitioner] != UserType.None;
    }

    function getCredentialUrl(uint256 tokenId) external view returns (string memory) {
        return tokenIdToUri[tokenId];
    }

    function balanceOf(address account, uint256 id) external view returns (uint256) {
        return _balances[id][account];
    }

    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory) {
        uint256[] memory batchBalances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; i++) {
            batchBalances[i] = _balances[ids[i]][accounts[i]];
        }
        return batchBalances;
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(operator != msg.sender, "Cannot approve self");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address account, address operator) external view returns (bool) {
        return _operatorApprovals[account][operator];
    }

    function getPractitionerTokenId(address practitioner) external view returns (uint256) {
        return practitionerToTokenId[practitioner];
    }

    function getTokenUri(uint256 tokenId) external view returns (string memory) {
        return tokenIdToUri[tokenId];
    }

    function getCredentialExpiry(uint256 tokenId) external view returns (uint256) {
        return tokenIdToExpiry[tokenId];
    }
}
