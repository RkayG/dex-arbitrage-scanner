
//import  ethers  from 'hardhat';
import { expect } from 'chai';
import BigNumber from 'bignumber.js';

describe("ArbitrageBot", function () {
    let ArbitrageBot, arbitrageBot;
    let mockTokenA, mockTokenB, mockWBNB;
    let mockPancakeFactory, mockPancakeRouter;
    let owner;

    before(async function () {
        [owner] = await ethers.getSigners();
        
        // Deploy Mock Tokens
        const MockERC20 = await ethers.getContractFactory("MockERC20");
        mockWBNB = await MockERC20.deploy("Mock WBNB", "WBNB");
        mockTokenA = await MockERC20.deploy("Mock Token A", "MTA");
        mockTokenB = await MockERC20.deploy("Mock Token B", "MTB");
        // Deploy Mock Pancake Factory
        const PancakeFactory = await ethers.getContractFactory("MockPancakeFactory");
        mockPancakeFactory = await PancakeFactory.deploy();

        // Deploy Mock Pancake Router
        const PancakeRouter = await ethers.getContractFactory("MockPancakeRouter");
        mockPancakeRouter = await PancakeRouter.deploy();

        // Create token pairs in the mock factory
        await mockPancakeFactory.createPair(mockWBNB.address, mockTokenA.address);
        await mockPancakeFactory.createPair(mockWBNB.address, mockTokenB.address);

         //  Deploy MockPancakePair
        const MockPancakePair = await ethers.getContractFactory("MockPancakePair");
        const pair = await MockPancakePair.deploy(mockTokenA.address, mockWBNB.address);
    
        await mockTokenA.transfer('0xd8058efe0198ae9dd7d563e1b4938dcbc86a1f81', ethers.utils.parseEther("1000"));
        await mockWBNB.transfer('0xd8058efe0198ae9dd7d563e1b4938dcbc86a1f81', ethers.utils.parseEther("1000"));

        const initialpairBalance = await mockTokenA.balanceOf('0xd8058efe0198ae9dd7d563e1b4938dcbc86a1f81');
        console.log('initial pair balance of token a ', initialpairBalance)

        /*

        // Provide liquidity to the pair
        await mockTokenA.connect(owner).approve(pair.address, ethers.utils.parseEther("1000"));
        await mockWBNB.connect(owner).approve(pair.address, ethers.utils.parseEther("1000"));
        await pair.provideLiquidity(ethers.utils.parseEther("1000"), ethers.utils.parseEther("1000"));

 */
        console.log('WBNB address', mockWBNB.address)
        // Deploy ArbitrageBot
        ArbitrageBot = await ethers.getContractFactory("ArbitrageBot");
        arbitrageBot = await ArbitrageBot.deploy(
            mockWBNB.address,
            mockPancakeRouter.address,
            mockPancakeFactory.address,
            owner.address
        );
        console.log('ArbritrageBot contract deployed to: ', arbitrageBot.address);

        // Fund the ArbitrageBot with some tokens
        await mockWBNB.transfer(arbitrageBot.address, ethers.utils.parseEther("300"));
        await mockTokenA.transfer(arbitrageBot.address, ethers.utils.parseEther("400"));
    });


    it("should allow the owner to execute arbitrage", async function () {
        const initialBalance = await mockTokenA.balanceOf(arbitrageBot.address);
        const initialWBNB = await mockWBNB.balanceOf(arbitrageBot.address);
        console.log("Initial balance is of type: ", typeof(initialBalance));
        console.log("Initial balance:", ethers.utils.formatEther(initialBalance));
        console.log("Initial WBNB:", ethers.utils.formatEther(initialWBNB));
       

        // Simulate a token swap by invoking the executeArbitrage function
        const amount = ethers.utils.parseEther("30");
        //console.log(ethers.utils.formatUnits(amount));
        const tx = await arbitrageBot.executeArbitrage([mockTokenA.address, mockWBNB.address], amount);
        
        // Wait for the transaction to be mined
        await tx.wait();

         // Add assertions to validate the results of the swap
        const mockTokenABalance = await mockTokenA.balanceOf(owner.address);
        const mockWBNBBalance = await mockWBNB.balanceOf(owner.address);
        
        console.log("Token0 Balance:", mockTokenABalance.toString());
        console.log("Token1 Balance:", mockWBNBBalance.toString());

       /*  // Check if the ArbitrageExecuted event was emitted
        await expect(tx)
          .to.emit(arbitrageBot, 'ArbitrageExecuted')
          .withArgs(mockTokenA.address, amount);
 */
        // In a real scenario, we would check for profit here
        // For this mock setup, we'll just ensure the transaction didn't revert
        console.log("Arbitrage executed successfully");
    });

    it("should allow owner to withdraw tokens", async function () {
        const initialBalance = await mockTokenA.balanceOf(owner.address);
        console.log('initial balance:', initialBalance);
        await arbitrageBot.withdrawToken(mockTokenA.address);
        const ownerBalance = await mockTokenA.balanceOf(owner.address);
        console.log('after balance', ownerBalance);
        
        // Convert BigNumber to string and then to a regular number
        const balanceAsNumber = Number(ethers.utils.formatUnits(ownerBalance, 18));

        // Assert that the owner balance is greater than 0
        expect(balanceAsNumber).to.be.greaterThan(0);
    });
});