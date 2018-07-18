/** 
  * This contract specifically stores all the user
  * data to avoid inconsistencies during Blockvitae
  * contract update.
  *
  * This files acts as the DB layer between the
  * model User.sol and the controller Blockvitae.sol
  */

pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2; // experimental

// imports
import "./User.sol";

contract DB {
    
    using User for User.UserMain;

    // total registered users
    uint public totalUsers;

    // constructor function
    constructor() public {
        totalUsers = 0;
    } 

    // list mapping of all users
    mapping(address => User.UserMain) internal users;

    // list mapping of all userNames
    mapping(string => address) internal userNames;
}
