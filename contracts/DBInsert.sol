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

contract DBInsert{

    DB private db;
    
    constructor(DB _db) public {
        db = _db;
    }

    modifier isOwner(address _sender) {
      require(db.isOwnerDB(_sender));
      _;
    }
    
    // @description
    // inserts or updates a new UserDetail in the database mapping
    // this function also updates a new username
    //
    // @param User.UserDetail _personal
    // UserDetail struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserDetail(User.UserDetail _personal, address _user) public isOwner(msg.sender) {
        // if new requested userName is available
        if (db.getUserNameAddr(_personal.userName, msg.sender) == address(0x0)) { 
            // if user exists
            // and user's old userName is not equal to the new one
            // string comparison not allowed. Therefore, compare hashes.
            if (db.isExists(_user, msg.sender)
                && keccak256(abi.encodePacked(db.getUserDetail(_user, msg.sender).userName)) 
                                != keccak256(abi.encodePacked(_personal.userName, msg.sender))) {
                // temp save oldUserName
                bytes32 oldUserName = db.getUserDetail(_user, msg.sender).userName;

                // update personal details
               db.setUserDetail(_personal, _user, msg.sender);

                // update userName
                db.setUserNameAddr(oldUserName, address(0x0), msg.sender);

                // assign new userName
                db.setUserNameAddr(_personal.userName, _user, msg.sender);
            }
            // user doesn't exist and requested userName is available
            else if (!db.isExists(_user, msg.sender)) {
                // update personal details
                db.setUserDetail(_personal, _user, msg.sender);  

                // assign new userName
                db.setUserNameAddr(_personal.userName, _user, msg.sender);
                // update new user count
                db.incrementTotalUsers(msg.sender);
            }  
            db.persistUser(_user, msg.sender); 
        }
        // user exits but hasn't requested for a new userName
        else {
            // existing userName is same as the one sent in the request
            if (keccak256(abi.encodePacked(db.getUserDetail(_user, msg.sender).userName))
                    == keccak256(abi.encodePacked(_personal.userName, msg.sender))) {
                // update personal details
                db.setUserDetail(_personal, _user, msg.sender);

                // assign new userName
                db.setUserNameAddr(_personal.userName, _user, msg.sender);
            }

            db.persistUser(_user, msg.sender);
        }
    }

    // @description
    // inserts or updates a new UserSocial in the database mapping
    //
    // @param User.UserSocial _social
    // UserSocial struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserSocial(User.UserSocial _social, address _user) public isOwner(msg.sender) {
        db.setUserSocial(_social, _user, msg.sender);
    }

    // @description
    // inserts or updates a new UserProject in the database mapping
    // 
    // @param User.UserProject
    // UserProject struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserProject(User.UserProject _project, address _user) public isOwner(msg.sender) {
        db.setUserProject(_project, _user, msg.sender);
    }

    // @description
    // inserts or update a new UserWorkExp in the database mapping
    //
    // @param User.UserWorkExp _workExp
    // UserWorkExp struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserWorkExp(User.UserWorkExp _workExp, address _user) public isOwner(msg.sender) {
        db.setUserWorkExp(_workExp, _user, msg.sender);
    }

    // @description
    // inserts or updates a new UserSkill in the database
    //
    // @param User.UserSkill _skills
    // UserSkill struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserSkill(User.UserSkill _skills, address _user) public isOwner(msg.sender) {
        db.setUserSkills(_skills, _user, msg.sender);
    }

    // @description
    // inserts or updates a new UserIntroduction in the database
    //
    // @param User.UserIntroduction _introduction
    // UserIntroduction struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserIntroduction(User.UserIntroduction _introduction, address _user) public isOwner(msg.sender) {
        db.setUserIntro(_introduction, _user, msg.sender);
    }

    // @description
    // inserts or updates a new UserEducation in the database
    //
    // @param User.UserEducation _education
    // UserEducation struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserEducation(User.UserEducation _education, address _user) public isOwner(msg.sender) {
        db.setUserEducation(_education, _user, msg.sender);
    }
    
    // @description
    // inserts or updates a new UserPublication in the database
    //
    // @param User.UserPublication _publication
    // UserPublication struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserPublication(User.UserPublication _publication, address _user) public isOwner(msg.sender) {
        db.setUserPublication(_publication, _user, msg.sender);
    }
}
