// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "hardhat/console.sol";

import "./interfaces/IPancakeRouter02.sol";
import "./interfaces/IPancakePair.sol";
import "./interfaces/IPancakeFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// mocks
import "./mocks/MockPancakePair.sol";
import "./mocks/MockPancakeRouter.sol";
import "./mocks/MockPancakeFactory.sol";

contract ArbitrageBot is Ownable {
    address public WBNB; //= 0x5FbDB2315678afecb367f032d93F642f64180aa3;// 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public PANCAKE_ROUTER; //= 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0; // 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public PANCAKE_FACTORY; //= 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512; // 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;

    MockPancakeRouter public pancakeRouter;
    MockPancakeFactory public pancakeFactory;

    event ArbitrageExecuted(address indexed path, uint256 amount);

    constructor(
        address _wbnb,
        address _pancakeRouter,
        address _pancakeFactory,
        address initialOwner
        ) Ownable(initialOwner) {
            WBNB = _wbnb;
            PANCAKE_ROUTER = _pancakeRouter;
            PANCAKE_FACTORY = _pancakeFactory;
            pancakeRouter = MockPancakeRouter(PANCAKE_ROUTER);
            pancakeFactory = MockPancakeFactory(PANCAKE_FACTORY);
    }

    function executeArbitrage(
        address[] calldata _path,
        uint256 _amount
    ) external onlyOwner {
        require(_path.length >= 2, "Path must have at least 2 tokens");
        require(_amount > 0, "Invalid amount");

         // Check if the contract has enough of the required token for the swap
        uint256 tokenBalance = IERC20(_path[0]).balanceOf(address(this));
        require(tokenBalance >= _amount, "Insufficient token balance for swap");


        // Borrow BNB from PancakeSwap
        address pair = pancakeFactory.getPair(_path[0], WBNB);
        require(pair != address(0), "Pair does not exist");
        console.log("=================================================================");
        console.log("Executing swap with pair: ", pair);
        console.log("First token in path: ", _path[0]);
        console.log("Second token in path: ", _path[1]);
        console.log("Amount: ", _amount);
        console.log("WBNB address: ", WBNB);
        console.log("Is first token WBNB?: ", _path[0] == WBNB);

        
        MockPancakePair(pair).swap(
            _path[0] == WBNB ? 0 : _amount,
            _path[0] == WBNB ? _amount : 0,
            address(this),
            abi.encode(_path)
        );
        console.log("arbitrage succeeded");
        emit ArbitrageExecuted(_path[0], _amount);
    }

    function pancakeCall(address _sender, uint256 _amount0, uint256 _amount1, bytes calldata _data) external {
        require(_sender == address(this), "Sender must be this contract");
        require(msg.sender == PANCAKE_ROUTER, "Only PancakeSwap can call this function");

         // Ensure that one of the amounts (either _amount0 or _amount1) is non-zero
        require(_amount0 > 0 || _amount1 > 0, "At least one of the amounts must be non-zero");


        address[] memory path = abi.decode(_data, (address[]));
        uint256 amountToken = _amount0 == 0 ? _amount1 : _amount0;

        // Approve router to spend the borrowed tokens
        IERC20(path[0]).approve(address(pancakeRouter), amountToken);

        // Perform the arbitrage
        pancakeRouter.swapExactTokensForTokens(
            amountToken,
            10, // Accept any amount of tokens
            path,
            address(this),
            block.timestamp
    );

        // Calculate the loan amount to repay
        uint256 fee = ((amountToken * 3) / 997) + 1;
        uint256 amountToRepay = amountToken + fee;

        // Repay the loan
        IERC20(path[0]).transfer(msg.sender, amountToRepay);

        // Calculate profit
        uint256 profit = IERC20(path[path.length - 1]).balanceOf(address(this));
        require(profit > 0, "Arbitrage did not yield profit");

        // Transfer profit to owner
        IERC20(path[path.length - 1]).transfer(owner(), profit);
    }

    // Function to withdraw tokens
    function withdrawToken(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");
        token.transfer(owner(), balance);
    }

    // Function to receive BNB
    receive() external payable {}
}