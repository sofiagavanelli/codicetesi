// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
/** 
Shared for common struct, variables and functions
*/
abstract contract Shared {

    enum Type{A,B,C}

    struct InsuranceItem {
        string provider;
        string name;
        Type insurance_type;
        uint256 price;
    }
    

}