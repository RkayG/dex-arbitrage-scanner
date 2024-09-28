// ===== A mock version of PancakeFactory to create pairs. =====

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MockPancakePair.sol";

contract MockPancakeFactory {
    mapping(address => mapping(address => address)) public pairs;

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(pairs[tokenA][tokenB] == address(0), "Pair already exists");
        MockPancakePair newPair = new MockPancakePair(tokenA, tokenB);
        pairs[tokenA][tokenB] = address(newPair);
        pairs[tokenB][tokenA] = address(newPair); // For reverse lookup
        return address(newPair);
    }

    function getPair(address tokenA, address tokenB) external view returns (address pair) {
        return pairs[tokenA][tokenB];
    }
}
