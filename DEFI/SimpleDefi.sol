// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
    import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";

contract MyDefi {
    address public token1;
    address public token2;
    uint256 public reserve1;
    uint256 public reserve2;
    uint256 public FeePercentage;

    address public _owner;

    AggregatorV3Interface internal priceFeed1;


    event Swap(address indexed _fromToken, address indexed _toToken, uint256 _amountIn, uint256 _amountOut);

    constructor(address _token1, address _token2, address _priceFeed1 , uint256 _FeePercentage) {
        token1 = _token1;
        token2 = _token2;
        priceFeed1 = AggregatorV3Interface(_priceFeed1);
        FeePercentage = _FeePercentage;
        _owner = msg.sender;
        
    }

    function getReservee() public view returns (uint256 , uint256) {
        _reserve1 = reserve1;
        _reserve2 = reserve2;

        return (_reserve1, _reserve2);
    }

    function AddLiquidity (uint256 _Amount1 , uint256 _Amount2) external{
        require(_Amount1 > 0 && _Amount2 > 0 , "Amount must be greater than 0");
        IERC20(token1).transferFrom(msg.sender, address(this), _Amount1);
        IERC20(token2).transferFrom(msg.sender, address(this), _Amount2);
        reserve1 += _Amount1;
        reserve2 += _Amount2;
    }
    function RemoveLiquidity(uint256 liquidity) external{
        require(liquidity > 0 , "Amount must be greater than 0");
        uint256 totalSupply = IERC20(address(this)).balanceOf(address(this));
        uint256 _Amount1 = liquidity * reserve1 / totalSupply;
        uint256 _Amount2 = liquidity * reserve2 / totalSupply;
        require(_Amount1 > 0 && _Amount2 > 0 , "Amount must be greater than 0");

        reserve1 -= _Amount1;
        reserve2 -= _Amount2;
        IERC20(token1).transfer(msg.sender, _Amount1);
        IERC20(token2).transfer(msg.sender, _Amount2);


    }

    function getLastestPrice () public view returns (uint256) {
        (,int price,,,) = priceFeed1.latestRoundData();
        require(price > 0 , "Invalid price");
        return uint256(price);
    }


    
    function Swap(uint256 _amountIn,uint256 _amountOutMin,address _to) external{
        require(_amountIn > 0 , "Amount must be greater than 0");
        uint256 amountOut = _amountIn*getLastestPrice()/1e8;
        require(amountOut > 0 , "Invalid amount");
        require(amountOut >= _amountOutMin , "Invalid amount out min");

        uint256 fee = amountOut * FeePercentage / 100;


        uint256 amountInAfterTransfer = _amountIn - fee;

        IERC20(token1).transferFrom(msg.sender, address(this), _amountIn);

        IERC20(token2).transfer(_to, amountOut);

        reserve1 += amountInAfterTransfer;
        reserve2 -= amountOut;
        
        IERC20(token2).transfer(_owner, fee);




        emit Swap(token1, token2, _amountIn, amountOut);




    }

    // function owner() public view virtual returns (address) {
    //     return Ownable.owner();
    // }







}