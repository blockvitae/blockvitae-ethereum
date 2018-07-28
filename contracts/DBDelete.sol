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
import "./DB.sol";

contract DBDelete {

  DB private db;

  constructor(DB _db) public {
      db = _db;
  }

  modifier isOwner(address _sender) {
      require(db.isOwnerDB(_sender));
      _;
  }
    

  // @description
  // deletes the education for the given index and address
  //
  // @param uint _index
  // index of the education to be deleted
  //
  // @param address _user
  // address of the user whose education is to be deleted
  function deleteEducation(uint _index, address _user) public isOwner(msg.sender) {
      require(!db.getUserEducation(_user, msg.sender)[_index].isDeleted);
      db.deleteUserEducation(_index, _user, msg.sender);
  }

  // @description
  // deletes the publication for the given index and address
  //
  // @param uint _index
  // index of the publication to be deleted
  //
  // @param address _user
  // address of the user whose publication is to be deleted
  function deletePublication(uint _index, address _user) public isOwner(msg.sender) {
      require(!db.getUserPublication(_user, msg.sender)[_index].isDeleted);
      db.deleteUserPublication(_index, _user, msg.sender);
  }

  // @description
  // deletes the project for the given index and address
  //
  // @param uint _index
  // index of the project to be deleted
  //
  // @param address _user
  // address of the user whose project is to be deleted
  function deleteProject(uint _index, address _user) public isOwner(msg.sender) {
      require(!db.getUserProject(_user, msg.sender)[_index].isDeleted);
      db.deleteUserProject(_index, _user, msg.sender);
  }

  // @description
  // deletes the work experience for the given index and address
  //
  // @param uint _index
  // index of the workexp to be deleted
  //
  // @param address _user
  // address of the user whose project is to be deleted
  function deleteWorkExp(uint _index, address _user) public isOwner(msg.sender) {
      require(!db.getUserWorkExp(_user, msg.sender)[_index].isDeleted);
      db.deleteUserWorkExp(_index, _user, msg.sender);
  }
}