// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;


interface IAdminRole{
    function isAdmin(address user) external view returns(bool);
    function issueNftCredentialToPractitioner(address user) external;
    function revokeNftCredentialFromPractitioner(address user) external;
}