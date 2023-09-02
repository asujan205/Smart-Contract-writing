// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}



contract DEXCurve {


    address private _Owner;

    uint256 public fee;
    uint256 public admin_fee;
    // uint256 public _A;
    address[2] private Tokens;

     uint256[2] public balances;
     uint256 public Init_A;
     uint256 public Future_A;
     uint256 public Init_A_time;
     uint256 public Future_A_time;

     uint256 totalSupply;
     uint256 private constant FEE_INDEX = 1;
     uint256 constant FEE_DENOMINATOR = 10**10;

      address  public token;




    // address private TokenSwap ="0x6B175474E89094C44Da98b954EedeAC495271d0F";







    constructor(address [2] memory _tokens,

    uint256 _A, uint256 _fee,uint256 _admin_fee
    
    ) {
        Tokens = _tokens;
        Init_A =_A;
        Future_A = _A;
        fee = _fee;
        admin_fee = _admin_fee;
        _Owner = msg.sender;
    }

function _AC() internal view returns (uint256) {
    uint256 t1 = Future_A_time;
    uint256 A1 = Future_A;

    if (block.timestamp < t1) {
        uint256 A0 = Init_A;
        uint256 t0 = Init_A_time;

        if (A1 > A0) {
            return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0);
        } else {
            return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0);
        }
    } else {
        return A1;
    }
}



function get_D(uint256[2] memory xp, uint256 amp) internal pure returns (uint256) {
    uint256 S = 0;
    for (uint256 i = 0; i < 2; i++) {
        S += xp[i];
    }
    if (S == 0) {
        return 0;
    }

    uint256 Dprev = 0;
    uint256 D = S;
    uint256 Ann = amp * 2;
    for (uint256 i = 0; i < 255; i++) {
        uint256 D_P = D;
        for (uint256 j = 0; j < 2; j++) {
            D_P = (D_P * D) / (xp[j] * 2);  // If division by 0, this will be borked: only withdrawal will work. And that is good
        }
        Dprev = D;
        D = ((Ann * S + D_P * 2) * D) / ((Ann - 1) * D + (2 + 1) * D_P);
        // Equality with the precision of 1
        if (D > Dprev) {
            if (D - Dprev <= 1) {
                break;
            }
        } else {
            if (Dprev - D <= 1) {
                break;
            }
        }
    }
    return D;
}


function AddLiquidity(uint256[2] memory _amounts, uint256 min_mint_amount) external{
      uint256[2] memory fees;

        uint256 _fee = (fee * 2) / (4 * (2 - 1));
        uint256 _admin_fee = admin_fee;
        uint256 amp = _AC();
        //  uint256 token_supply = IERC20(address(this)).totalSupply();

         uint256 D0 = 0;
         uint256[2] memory old_balances = balances;

         if (totalSupply > 0){
             D0 = get_D(old_balances,amp);
         }

             uint256[2] memory new_balances = old_balances;

             for (uint256 i = 0; i < 2; i++) {
            uint256 in_amount = _amounts[i];
            if (totalSupply == 0) {
                require(in_amount > 0, "Initial deposit requires all coins");
            }
            address in_coin = Tokens[i];

            if (in_amount > 0) {
                if (i == FEE_INDEX) {
                    in_amount = IERC20(in_coin).balanceOf(address(this)) - in_amount;
                }

                require(
                    IERC20(in_coin).transferFrom(msg.sender, address(this), in_amount),
                    "TransferFrom failed"
                );

                if (i == FEE_INDEX) {
                    in_amount = IERC20(in_coin).balanceOf(address(this)) - in_amount;
                }
            }

            new_balances[i] = old_balances[i] + in_amount;
        }

          uint256 D1 = get_D(new_balances, amp);
    require(D1 > D0, "Invariant not satisfied");

    // Recalculate invariant D2 accounting for fees
    uint256 D2 = D1;
    if (totalSupply > 0) {
        for (uint256 i = 0; i < 2; i++) {
            uint256 ideal_balance = (D1 * old_balances[i]) / D0;
            uint256 difference = (ideal_balance > new_balances[i]) ? (ideal_balance - new_balances[i]) : (new_balances[i] - ideal_balance);
            fees[i] = (_fee * difference) / FEE_DENOMINATOR;
            balances[i] = new_balances[i] - ((fees[i] * _admin_fee) / FEE_DENOMINATOR);
            new_balances[i] -= fees[i];
        }
        D2 = get_D(new_balances, amp);
    } else {
        balances = new_balances;
    }

 uint256 mint_amount = 0;

    if (totalSupply == 0) {
        mint_amount = D1;
    } else {
        mint_amount = (totalSupply * (D2 - D0)) / D0;
    }

    require(mint_amount >= min_mint_amount, "Slippage screwed you");

    // we need to mint our token

    // token.mint(msg.sender, mint_amount);




}





function RemoveLiquidity(uint256 _amount, uint256[2] memory min_amounts) external {

// uint256 total_supply = token.totalSupply();
    uint256[2] memory amounts;
    uint256[2] memory fees; // Fees are unused but included for historical reasons
    
    for (uint256 i = 0; i < 2; i++) {
        uint256 value = (balances[i] * _amount) / totalSupply;
        require(value >= min_amounts[i], "Withdrawal resulted in fewer coins than expected");
        balances[i] -= value;
        amounts[i] = value;
        
        (bool success, ) = Tokens[i].call(abi.encodeWithSelector(0xa9059cbb, msg.sender, value)); // transfer(address,uint256) selector
        require(success, "Transfer failed");
    }
    
    // token.burnFrom(msg.sender, _amount);



}





            
    





    






}











