# Simple ERC20 Flash Swap

This repository contains a professional-grade Solidity smart contract for executing Flash Swaps on Uniswap V2 (or compatible DEXs like PancakeSwap). 

## How It Works
Flash Swaps allow you to withdraw any amount of any ERC20 token held in a Uniswap V2 pair for free, provided that by the end of the transaction, you either:
1. Pay for the tokens.
2. Return the tokens plus a small fee (0.3%).

## Use Cases
* **Arbitrage:** Capitalize on price differences between exchanges without owning the underlying capital.
* **Liquidations:** Liquidate under-collateralized loans on platforms like Aave or Compound.
* **Refinancing:** Swap high-interest loans for lower ones in a single click.

## Quick Start
1. Deploy `FlashSwap.sol` to an Ethereum-compatible network (Goerli, Sepolia, Polygon).
2. Call the `startSwap` function with the token address and amount you wish to borrow.
3. The `uniswapV2Call` function will execute your custom logic.

## Security Note
Always ensure your repayment logic accounts for the 0.3% Uniswap fee, or the transaction will revert.

## License
MIT
