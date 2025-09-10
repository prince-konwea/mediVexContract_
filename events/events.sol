// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface HealthCareEvent{
     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);
}