// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
/** 
Shared for common struct, variables and functions
*/
abstract contract Shared {

    /*****gestione scadenza*/
    uint256 last_access = 0;
    //**********************/

    uint256 eth_index = 1000000000000000000;

    enum Type{A,B,C}

    struct InsuranceItem {
        //string provider; //ma perché non wallet address del provider???? - messo address nella tesi
        address payable provider;
        //string id; //why
        Type insurance_type;
        uint256 price;
    }
    
    struct Request {
        address payable clientWallet;
        Type t;
        uint256 maxp;
        uint256 scadenza;
    }

    /******************clientInfo(name, id, bday, discount, pending, iban) */
    struct clientInfo{
        string name;
        uint birth;
        string discount_n;

        uint pending;
        
        address payable _clientWallet;
    }

     /******************gestione scadenza */
    function nowTime() public returns (uint256) {
        last_access = block.timestamp;
        return last_access;
    }


    ///per mandare ether
     function sendDeposit(address payable _to, uint _price) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: _price}("");
        require(sent, "Failed to send Ether");
    }

}