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

// imports
import "./Blockvitae.sol";

contract BlockvitaeDelete is Blockvitae {

    Blockvitae blockvitae;

    // @Reference: 
    // http://solidity.readthedocs.io/en/latest/contracts.html#arguments-for-base-constructors
    constructor(DB _db, DBInsert _dbInsert, DBGetter _dbGetter, DBDelete _dbDelete, Blockvitae _blockvitae)
    Blockvitae(_db,_dbInsert, _dbGetter, _dbDelete) 
    public {
      // set this contract as the owner of DB contract
      // to avoid any external calls to DB contract
      // All calls to DB contract should pass through this
      // contract
      _db.setOwner(address(this));
      blockvitae = _blockvitae;
    }

    // if user is whitelisted to create account
    modifier isWhitelisted() {
        require(blockvitae.whitelist(msg.sender) || blockvitae.allWhitelisted());
        _;
    }

    // @description
    // deletes the education for the given index and address
    //
    // @param uint _index
    // index of the education to be deleted
    function deleteUserEducation(uint _index)
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        dbDelete.deleteEducation(_index, msg.sender);
    }

    // @description
    // deletes the publication for the given index and address
    //
    // @param uint _index
    // index of the publication to be deleted
    function deleteUserPublication(uint _index)
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        dbDelete.deletePublication(_index, msg.sender);
    }

    // @description
    // deletes the project for the given index and address
    //
    // @param uint _index
    // index of the project to be deleted
    function deleteUserProject(uint _index)
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        dbDelete.deleteProject(_index, msg.sender);
    }

    // @description
    // deletes the workexp for the given index and address
    //
    // @param uint _index
    // index of the workexp to be deleted
    function deleteUserWorkExp(uint _index)
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        dbDelete.deleteWorkExp(_index, msg.sender);
    }
}