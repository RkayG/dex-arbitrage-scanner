async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
  
    const WBNB = await ethers.getContractFactory("MockERC20");
    const wbnb = await WBNB.deploy("Wrapped BNB", "WBNB");
    console.log("WBNB deployed to:", wbnb.address);
  
    const PancakeFactory = await ethers.getContractFactory("MockPancakeFactory");
    const factory = await PancakeFactory.deploy();
    console.log("PancakeFactory deployed to:", factory.address);
  
    const PancakeRouter = await ethers.getContractFactory("MockPancakeRouter");
    const router = await PancakeRouter.deploy();
    console.log("PancakeRouter deployed to:", router.address);
  
    const ArbitrageBot = await ethers.getContractFactory("ArbitrageBot");
    const arbitrageBot = await ArbitrageBot.deploy(deployer.address);
    console.log("ArbitrageBot deployed to:", arbitrageBot.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  