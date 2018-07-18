/**
 * This contract acts as a controller for front-end
 * requests. The DB file is separate incase, solidity adds
 * functionality to return structs. In that case, only
 * this contract needs to be redeployed and data migration
 * will not be needed as the data is stored in DB.sol
 * contract.
 */
pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2; // experimental

// import user.sol contract
import "./User.sol";
import "./DBGetter.sol";
import "./DBDelete.sol";
import "./DBInsert.sol";

// @title Blockvitae for CV
contract Blockvitae {

    using User for User.UserMain;

    // DB
    DBInsert internal dbInsert;

    // Getter DB
    DBGetter internal dbGetter;

    // Delete DB
    DBDelete internal dbDelete;

    // owner of the contract
    address public owner;

    // if user is whitelisted to create account
    mapping(address => bool) public whitelist;

    // if anyone is allowed to create account
    bool public allWhitelisted;

    // checks if the user has an account or not
    modifier userExists() {
        require(dbGetter.isExists(msg.sender));
        _;
    }

    // checks if the sender address has been registered before or not
    modifier newAccount() {
        require(!dbGetter.isExists(msg.sender));
        _;
    }

    // checks if the address is not zero
    modifier addressNotZero() {
        require(msg.sender != address(0));
        _;
    }

    // check for the owner
    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

    // if user is whitelisted to create account
    modifier isWhitelisted() {
        require(whitelist[msg.sender] || allWhitelisted);
        _;
    }

    // sets the owner of the contract
    constructor(DBInsert _dbInsert, DBGetter _dbGetter, DBDelete _dbDelete) public {
        dbInsert = _dbInsert;
        dbGetter = _dbGetter;
        dbDelete = _dbDelete;
        owner = msg.sender;
        allWhitelisted = false;
    } 
}