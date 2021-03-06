pragma solidity ^0.5.5;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    using SafeMath for uint;

    constructor(uint rate, address payable wallet, ERC20 token, uint goal, uint cap, uint openingTime, uint closingTime)
        CappedCrowdsale(cap)
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        public {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    
    uint goal = 500;
    uint cap = 5000;

    constructor(string memory name, string memory symbol, address payable wallet) public {
        PupperCoin token = new PupperCoin(name, symbol, 0); 
        token_address = address(token); 
        PupperCoinSale pupper_token_sale = new PupperCoinSale(1, wallet, token, goal, cap, now, now + 24 weeks);
        token_sale_address = address(pupper_token_sale);
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}