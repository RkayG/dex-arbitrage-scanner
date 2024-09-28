// ===== A mock version of PancakeRouter. ===== 


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IPancakeRouter02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockPancakeRouter is IPancakeRouter02 {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external override returns (uint256[] memory amounts) {
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
        // Mock swap logic
        uint256 amountOut = amountIn; // Assume 1:1 for simplicity in mock
        IERC20(path[path.length - 1]).transfer(to, amountOut);

        //amounts = new uint256 ;
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }
}
