// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IErc1155Healthcare {
   function balanceOf(address account, uint256 id) external view returns(uint256);
   function setApprovalForAll(address operator_,bool approved) external;
   function isApprovedForAll( address account, address operator) external view returns(bool);
   function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata) external;
}