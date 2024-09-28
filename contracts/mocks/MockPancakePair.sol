// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IPancakePair.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockPancakePair is IPancakePair {
    address public token0;
    address public token1;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external override {
        require(amount0Out > 0 || amount1Out > 0, "Invalid amounts");

        require(IERC20(token0).balanceOf(msg.sender) >= amount0Out, 'contract does not have enough token0');
        require(IERC20(token1).balanceOf(msg.sender) >= amount1Out, 'contract does not have enough token1');
        // Check that the pair (this contract) has enough tokens
        require(IERC20(token0).balanceOf(address(this)) >= amount0Out, "Contract does not have enough token0");
        require(IERC20(token1).balanceOf(address(this)) >= amount1Out, "Contract does not have enough token1");

        // Transfer tokens to the recipient
        if (amount0Out > 0) {
            IERC20(token0).transfer(to, amount0Out);
        }
        if (amount1Out > 0) {
            IERC20(token1).transfer(to, amount1Out);
        }
    }
}