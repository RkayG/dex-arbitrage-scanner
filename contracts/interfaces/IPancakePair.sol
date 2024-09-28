// ===== This interface defines the PancakePair methods. =====

// SPDX-License-Identifier: MIT
   pragma solidity ^0.8.0;

   interface IPancakePair {
       function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
   }