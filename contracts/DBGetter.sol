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

contract DBGetter is DB {

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
    // checks if the user with given address exists
    //
    // @param address _user 
    // address of the user to be looked up
    //
    // @return bool 
    // true if user exists else false
    function isExists(address _user) public view isOwner returns(bool) {
        require(_user != address(0));
        return users[_user].exists;
    }
  // @description
  // finds the UserEducation struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserEducation[]
  // UserEducation struct array of the user with given address
  function findUserEducation(address _user) view public isOwner returns(User.UserEducation[]){
      return users[_user].education;
  }

  // @description
  // finds the UserPublication struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserPublication[]
  // UserPublication struct array of the user with given address
  function findUserPublication(address _user) view public isOwner returns(User.UserPublication[]){
      return users[_user].publications;
  }

  // @description
  // finds the UserSkill struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserSkill
  // UserSkill struct of the user with given address
  function findUserSkill(address _user) view public isOwner returns(User.UserSkill) {
      return users[_user].skills;
  }

  // @description
  // finds the UserIntroduction struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserIntroduction
  // UserIntroduction struct of the user with given address
  function findUserIntroduction(address _user) view public isOwner returns(User.UserIntroduction) {
      return users[_user].introduction;
  }

  // @description
  // finds the UserProject struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserProject[]
  // UserProject struct array of the user with given address
  function findUserProject(address _user) view public isOwner returns(User.UserProject[]) {
      return users[_user].projects;
  }

  // @description
  // finds the UserDetail struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserDetail
  // UserDetail struct of the user with given address
  function findUserDetail(address _user) view public isOwner returns(User.UserDetail) {
      return users[_user].personal;
  }

  // @description
  // finds the UserSocial struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserSocial
  // UserSocial struct of the user with given address
  function findUserSocial(address _user) view public isOwner returns(User.UserSocial) {
      return users[_user].social;
  }

  // @description
  // finds the UserWorkExp struct values for the given user
  //
  // @param address _user
  // address of the address of the user who's data is to be searched
  //
  // @return User.UserWorkExp
  // UserWorkExp struct of the user with given address
  function findUserWorkExp(address _user) view public isOwner returns(User.UserWorkExp[]) {
      return users[_user].work;
  }

  // @description
  // finds the address the given userName
  //
  // @param string _userName
  // userName of the user who's address is to be searched
  //
  // @return address
  // address of the user with given userName
  function findAddrForUserName(string _userName) view public isOwner returns(address) {
      require(users[userNames[_userName]].exists);
      return userNames[_userName];
  }

  // @description
  // Checks if the given username is available or taken
  //
  // @param string _userName
  // username to be checked
  //
  // @return bool
  // true if username is available else false
  function usernameExists(string _userName) view public isOwner returns(bool) {
      if (userNames[_userName] != address(0x0))
          return false;
      else
          return true;
  }
}