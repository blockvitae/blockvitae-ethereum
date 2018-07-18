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

contract DBDelete is DB {

    // address of the owner of the contract
    address public owner;

    constructor() public {
        // initially make this contract its own owner
        // This will be invalid once Blockvitae gets deployed
        // as it will become the owner of this contract
        owner = address(this);
    }

    // check for the owner
    // owner == address(this) will get
    // invalid after Blockvitae becomes owner of
    // this contract
    modifier isOwner() {
        require(owner == msg.sender || owner == address(this));
        _;
    }
    
    // @description
    // updates the current owner
    //
    // @param address _blockvitae
    // address of the Blockvitae contract
    function setOwner(address _blockvitae) public isOwner{
        owner = _blockvitae;
    }

  // @description
  // deletes the education for the given index and address
  //
  // @param uint _index
  // index of the education to be deleted
  //
  // @param address _user
  // address of the user whose education is to be deleted
  function deleteEducation(uint _index, address _user) public isOwner {
      require(!users[_user].education[_index].isDeleted);
      users[_user].education[_index].isDeleted = true;
  }

  // @description
  // deletes the publication for the given index and address
  //
  // @param uint _index
  // index of the publication to be deleted
  //
  // @param address _user
  // address of the user whose publication is to be deleted
  function deletePublication(uint _index, address _user) public isOwner {
      require(!users[_user].publications[_index].isDeleted);
      users[_user].publications[_index].isDeleted = true;
  }

  // @description
  // deletes the project for the given index and address
  //
  // @param uint _index
  // index of the project to be deleted
  //
  // @param address _user
  // address of the user whose project is to be deleted
  function deleteProject(uint _index, address _user) public isOwner {
      require(!users[_user].projects[_index].isDeleted);
      users[_user].projects[_index].isDeleted = true;
  }

  // @description
  // deletes the work experience for the given index and address
  //
  // @param uint _index
  // index of the workexp to be deleted
  //
  // @param address _user
  // address of the user whose project is to be deleted
  function deleteWorkExp(uint _index, address _user) public isOwner {
      require(!users[_user].work[_index].isDeleted);
      users[_user].work[_index].isDeleted = true;
  }
}