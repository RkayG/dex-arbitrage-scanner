// ==== This interface defines the functions of PancakeRouter that your contract interacts with. ===

// SPDX-License-Identifier: MIT
   pragma solidity ^0.8.0;

   interface IPancakeRouter02 {
       function swapExactTokensForTokens(
           uint amountIn,
           uint amountOutMin,
           address[] calldata path,
           address to,
           uint deadline
       ) external returns (uint[] memory amounts);

      // function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
   }