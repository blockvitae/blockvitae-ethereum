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

    DB internal db;

    // DB Insert
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

    // sets the owner of the contract
    constructor(DB _db, DBInsert _dbInsert, DBGetter _dbGetter, DBDelete _dbDelete) public {
        dbInsert = _dbInsert;
        dbGetter = _dbGetter;
        dbDelete = _dbDelete;
        owner = msg.sender;
        allWhitelisted = false;
        _db.setOwner(address(this));
        db = _db;
    }

    // checks if the user has an account or not
    modifier userExists() {
        require(db.isExists(msg.sender, address(this)));
        _;
    }

    // checks if the address is not zero
    modifier addressNotZero() {
        require(msg.sender != address(0));
        _;
    }

    // check for the owner
    modifier isOwner(address _sender) {
        require(owner == _sender);
        _;
    }

    function setOwner(address _owner, address _sender) public isOwner(_sender) {
        owner = _owner;
    }

    function addToWhiteList(address _user, address _sender) public isOwner(_sender) {
        whitelist[_user] = true;
    }

    function removeFromWhiteList(address _user, address _sender) public isOwner(_sender) {
        whitelist[_user] = false;
    }

    function setAllWhitelist(address _sender) public isOwner(_sender) {
        allWhitelisted = true;
    }
 
}