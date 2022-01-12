pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,                       // rate in TKNbits
        address payable wallet,         // wallet to send Ether
        PupperCoin token,              // the token
        uint cap,                     // total cap, in wei
        uint openTime,               // opening time in unix epoch seconds
        uint closeTime,             // closing time in unix epoch seconds
        uint goal                  // the minimum goal in wei
    )
        MintedCrowdsale()
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()

        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet, // sale beneficiary
        uint goal

    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);                        //  PupperCoin address 

        // PupperCoinSale set the goal, and set the open and close times to now and now + 24 weeks.
        uint goal = 300 wei;
        uint cap = 300 wei;
        
        PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token, goal, cap, now, now + 24 weeks);
        token_sale_address = address(pupper_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
