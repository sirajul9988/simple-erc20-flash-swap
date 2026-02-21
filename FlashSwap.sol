// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Pair {
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

contract FlashSwap {
    address public immutable factory;
    address public immutable WETH;

    constructor(address _factory, address _WETH) {
        factory = _factory;
        WETH = _WETH;
    }

    // 1. Initial trigger function
    function startSwap(address _tokenBorrow, uint _amount) external {
        address pair = IUniswapV2Factory(factory).getPair(_tokenBorrow, WETH);
        require(pair != address(0), "Pair does not exist");

        // Determine which token is token0 or token1 in the pair
        uint amount0Out = _tokenBorrow == WETH ? 0 : _amount;
        uint amount1Out = _tokenBorrow == WETH ? _amount : 0;

        // Passing data triggers the flash swap (uniswapV2Call)
        bytes memory data = abi.encode(_tokenBorrow, _amount);
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);
    }

    // 2. Callback function called by Uniswap
    function uniswapV2Call(address _sender, uint _amount0, uint _amount1, bytes calldata _data) external {
        address[] memory path = new address[](2);
        uint amountToken = _amount0 == 0 ? _amount1 : _amount0;
        
        (address tokenBorrow, uint amount) = abi.decode(_data, (address, uint));

        // --- CUSTOM ARBITRAGE/LOGIC GOES HERE ---
        // For demonstration, we just simulate the process.
        
        // 3. Repay the loan + 0.3% fee
        uint fee = ((amount * 3) / 997) + 1;
        uint amountToRepay = amount + fee;

        IERC20(tokenBorrow).transfer(msg.sender, amountToRepay);
    }
}
