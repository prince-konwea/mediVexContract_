// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {UserType} from "../config/enum.sol";

interface IAdminAction{
   function addAdmin(address admin) external;
   function removeAdmin(address adminToremove) external;
   function transferOwnership(address newOwner) external;
}

interface ICredentialManager{
    function issueNftCredentialToPractitioner(address user) external;
    function revokeNftCredentialFromPractitioner(address user) external;
    function renewNftCredentialForPractitioner(address user) external;
}

interface IVerifier{
    function isValidCredential(address practitioner, uint256 tokenId) external view returns(bool);
    function isRole(address practitioner, uint256 tokenId) external view returns(bool);
    function getCredentialUrl(uint256 tokenId) external view returns(string memory);
}

interface IUserRole{
    function assignRole(address user, UserType role) external;
    function getRole(address user) external view returns(UserType);
    function revokeRole(address user) external;
}