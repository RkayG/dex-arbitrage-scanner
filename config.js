module.exports = {
    SUPER_ARBIT_ADDRESS: "", // BSC Mainnet address of arbitrage contract(SuperArbit.sol)
    FACTORY_ADDRESSES: {
      // Factory contract addresses of chosen DEX'es
      pancake: "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73",
      biswap: "0x858E3312ed3A876947EA49d572A7C42DE08af7EE",
      nomiswap: "0xd6715A8be3944ec72738F0BFDC739d48C3c29349",
      mdex: "0x3CD1C46068dAEa5Ebb0d3f55F6915B10648062B8",
      babyswap: "0x86407bEa2078ea5f5EB5A52B2caA963bC1F889Da",
      safeswap: "0x4d05D0045df5562D6D52937e93De6Ec1FECDAd21",
      moonlift: "0xe9cABbC746C03010020Fd093cD666e40823E0D87",
      tendieswap: "0xb5b4aE9413dFD4d1489350dCA09B1aE6B76BD3a8",
      apeswap: "0x0841BD0B734E4F5853f0dD8d7Ea041c241fb0Da6",
      pandaswap: "0x9Ad32bf5DaFe152Cbe027398219611DB4E8753B3",
      teddyswap: "0x8A01D7F2e171c222372F0962BEA84b8EB5a3368E",
      kingkongswap: "0x3F0525D90bEBC8c1B7C5bE7C8FCb22E7B5e656c7",
      gibxswap: "0x97bCD9BB482144291D77ee53bFa99317A82066E8",
    },
    PIVOT_TOKEN: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c", // WBNB -> Wrapped BNB on BSC
    PAIRLIST_OUTPUT_FILE: "./pairsList.json",
    MATCHED_PAIRS_OUTPUT_FILE: "./matchedPairs.json",
    MAX_GAS: 2000000,
    BSC_GAS_PRICE: 5000000000,
    MAX_TRADE_INPUT: 10, // WBNB
  };
  