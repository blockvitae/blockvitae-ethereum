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

contract DBInsert is DB{

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
    // inserts or updates a new UserDetail in the database mapping
    // this function also updates a new username
    //
    // @param User.UserDetail _personal
    // UserDetail struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserDetail(User.UserDetail _personal, address _user) public isOwner {
        // if new requested userName is available
        if (userNames[_personal.userName] == address(0x0)) { 
            // if user exists
            // and user's old userName is not equal to the new one
            // string comparison not allowed. Therefore, compare hashes.
            if (users[_user].exists
                && keccak256(abi.encodePacked(users[_user].personal.userName)) 
                                != keccak256(abi.encodePacked(_personal.userName))) {
                // temp save oldUserName
                string memory oldUserName = users[_user].personal.userName;

                // update personal details
                users[_user].personal = _personal;

                // update userName
                userNames[oldUserName] = address(0x0);

                // assign new userName
                userNames[_personal.userName] = _user;
            }
            // user doesn't exist and requested userName is available
            else if (!users[_user].exists) {
                 // update personal details
                users[_user].personal = _personal;

                // assign new userName
                userNames[_personal.userName] = _user;

                // update new user count
                totalUsers++;
            }  

            persistUser(_user); 
        }
        // user exits but hasn't requested for a new userName
        else {
            // existing userName is same as the one sent in the request
            if (keccak256(abi.encodePacked(users[_user].personal.userName))
                    == keccak256(abi.encodePacked(_personal.userName))) {
                // update personal details
                users[_user].personal = _personal;

                // assign new userName
                userNames[_personal.userName] = _user;
            }

            persistUser(_user);
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
    function insertUserSocial(User.UserSocial _social, address _user) public isOwner {
        users[_user].social = _social;
    }

    // @description
    // inserts or updates a new UserProject in the database mapping
    // 
    // @param User.UserProject
    // UserProject struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserProject(User.UserProject _project, address _user) public isOwner {
        users[_user].projects.push(_project);
    }

    // @description
    // inserts or update a new UserWorkExp in the database mapping
    //
    // @param User.UserWorkExp _workExp
    // UserWorkExp struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserWorkExp(User.UserWorkExp _workExp, address _user) public isOwner {
        users[_user].work.push(_workExp);
    }

    // @description
    // inserts or updates a new UserSkill in the database
    //
    // @param User.UserSkill _skills
    // UserSkill struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserSkill(User.UserSkill _skills, address _user) public isOwner {
        users[_user].skills = _skills;
    }

    // @description
    // inserts or updates a new UserIntroduction in the database
    //
    // @param User.UserIntroduction _introduction
    // UserIntroduction struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserIntroduction(User.UserIntroduction _introduction, address _user) public isOwner {
        users[_user].introduction = _introduction;
    }

    // @description
    // inserts or updates a new UserEducation in the database
    //
    // @param User.UserEducation _education
    // UserEducation struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserEducation(User.UserEducation _education, address _user) public isOwner {
        users[_user].education.push(_education);
    }
    
    // @description
    // inserts or updates a new UserPublication in the database
    //
    // @param User.UserPublication _publication
    // UserPublication struct for the user
    //
    // @param address _user
    // address of the user who's details are to be inserted or updated
    function insertUserPublication(User.UserPublication _publication, address _user) public isOwner {
        users[_user].publications.push(_publication);
    }

    // @description
    // creates the existance of the user
    // 
    // @param address _user
    // address of the user
    function persistUser(address _user) private {
        users[_user].exists = true;
        users[_user].owner = _user;
    }
}
