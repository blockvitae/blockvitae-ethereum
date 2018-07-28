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

contract DBGetter {

    DB private db;

    constructor(DB _db) public {
        db = _db;
    }

    modifier isOwner(address _sender) {
      require(db.isOwnerDB(_sender));
      _;
    }

   // @description 
   // checks if the user with given address exists
   //
   // @param address _user 
   // address of the user to be looked up
   //
   // @return bool 
   // true if user exists else false
   function isUserExists(address _user) public view isOwner(msg.sender) returns(bool) {
       require(_user != address(0));

       return db.isExists(_user, msg.sender);
   }  

  // @description
  // finds the UserEducation struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserEducation[]
  // UserEducation struct array of the user with given address
  function findUserEducation(address _user) view public isOwner(msg.sender) returns(User.UserEducation[]){
      return db.getUserEducation(_user, msg.sender);
  }

  // @description
  // finds the UserPublication struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserPublication[]
  // UserPublication struct array of the user with given address
  function findUserPublication(address _user) view public isOwner(msg.sender) returns(User.UserPublication[]){
      return db.getUserPublication(_user, msg.sender);
  }

  // @description
  // finds the UserSkill struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserSkill
  // UserSkill struct of the user with given address
  function findUserSkill(address _user) view public isOwner(msg.sender) returns(User.UserSkill) {
      return db.getUserSkill(_user, msg.sender);
  }

  // @description
  // finds the UserIntroduction struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserIntroduction
  // UserIntroduction struct of the user with given address
  function findUserIntroduction(address _user) view public isOwner(msg.sender) returns(User.UserIntroduction) {
      return db.getUserIntro(_user, msg.sender);
  }

  // @description
  // finds the UserProject struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserProject[]
  // UserProject struct array of the user with given address
  function findUserProject(address _user) view public isOwner(msg.sender) returns(User.UserProject[]) {
      return db.getUserProject(_user, msg.sender);
  }

  // @description
  // finds the UserDetail struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserDetail
  // UserDetail struct of the user with given address
  function findUserDetail(address _user) view public isOwner(msg.sender) returns(User.UserDetail) {
      return db.getUserDetail(_user, msg.sender);
  }

  // @description
  // finds the UserSocial struct values for the given user
  //
  // @param address _user
  // address of the user who's data is to be searched
  //
  // @return User.UserSocial
  // UserSocial struct of the user with given address
  function findUserSocial(address _user) view public isOwner(msg.sender) returns(User.UserSocial) {
      return db.getUserSocial(_user, msg.sender);
  }

  // @description
  // finds the UserWorkExp struct values for the given user
  //
  // @param address _user
  // address of the address of the user who's data is to be searched
  //
  // @return User.UserWorkExp
  // UserWorkExp struct of the user with given address
  function findUserWorkExp(address _user) view public isOwner(msg.sender) returns(User.UserWorkExp[]) {
      return db.getUserWorkExp(_user, msg.sender);
  }

  // @description
  // finds the address the given userName
  //
  // @param string _userName
  // userName of the user who's address is to be searched
  //
  // @return address
  // address of the user with given userName
  function findAddrForUserName(bytes32 _userName) view public isOwner(msg.sender) returns(address) {
      return db.getUserNameAddr(_userName, msg.sender);
  }

  // @description
  // Checks if the given username is available or taken
  //
  // @param string _userName
  // username to be checked
  //
  // @return bool
  // true if username is available else false
  function usernameExists(bytes32 _userName) view public isOwner(msg.sender) returns(bool) {
      if (db.getUserNameAddr(_userName, msg.sender) != address(0x0))
          return false;
      else
          return true;
  }
}