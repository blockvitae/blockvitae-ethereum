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

    // owners of DB
    mapping(address => bool) private owners;

    // list mapping of all users
    mapping(address => User.UserMain) public users;

    // list mapping of all userNames
    mapping(bytes32 => address) public userNames;

    // constructor function
    constructor() public {
        totalUsers = 0;
        owners[address(this)] = true;
    } 

    // check for the owner
    // address(this) gets true in the start but once all contracts
    // get deployed DbReset sets it to false to avoid any public access
    // Blockvitae Contracts becomes owner of
    // this contract
    modifier isOwner(address _sender) {
        require(owners[_sender] || owners[address(this)]);
        _;
    }

    // Check if the given sender is the owner of the DB contract
    function isOwnerDB(address _sender) public view isOwner(_sender) returns(bool){
        return (owners[_sender] || owners[address(this)]);
    }

    // @description
    // updates the current owner
    //
    // @param address _blockvitae
    // address of the Blockvitae contract
    function setOwner(address _blockvitae) public isOwner(_blockvitae){
        owners[_blockvitae] = true;
    }

    // @description
    // updates the current owner
    //
    // @param address _blockvitae
    // address of the Blockvitae contract
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function removeOwner(address _blockvitae, address _sender) public isOwner(_sender){
        owners[_blockvitae] = false;
    }

    // @description
    // gets the user detail of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserDetail
    function getUserDetail(address _user, address _sender) public view isOwner(_sender) returns(User.UserDetail){
        return users[_user].personal;
    }

    // @description
    // sets the user detail of given user
    //
    // @param User.UserDetail _personal
    // UserDetail struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserDetail(User.UserDetail _personal, address _user, address _sender) public isOwner(_sender) {
        users[_user].personal = _personal;
    }

    // @description
    // gets the address for the given username of given user
    //
    // @param bytes32 _user
    // username of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns address
    function getUserNameAddr(bytes32 _user, address _sender) public view isOwner(_sender) returns(address) {
        return userNames[_user];
    }

    // @description
    // sets the user name address of given user
    //
    // @param bytes32 _userName
    // username of the user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserNameAddr(bytes32 _userName, address _user, address _sender) public isOwner(_sender) {
        userNames[_userName] = _user;
    }

    // @description
    // gets the user social of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserSocial
    function getUserSocial(address _user, address _sender) public view isOwner(_sender) returns(User.UserSocial) {
        return users[_user].social;
    }

    // @description
    // sets the user social of given user
    //
    // @param User.UserSocial _social
    // UserSocial struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserSocial(User.UserSocial _social, address _user, address _sender) public isOwner(_sender) {
        users[_user].social = _social;
    }

    // @description
    // gets the user project of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserProject[]
    function getUserProject(address _user, address _sender) public view isOwner(_sender) returns(User.UserProject[]) {
        return users[_user].projects;
    }

    // @description
    // sets the user project of given user
    //
    // @param User.UserProject _project
    // UserProject struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserProject(User.UserProject _project, address _user, address _sender) public isOwner(_sender) {
        users[_user].projects.push(_project);
    }

    // @description
    // deletes the user project of given user
    //
    // @param uint _index
    // index of the project to be deleted
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function deleteUserProject(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].projects[_index].isDeleted = true;
    }

    // @description
    // gets the user work exp of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserWorkExp[]
    function getUserWorkExp(address _user, address _sender) public view isOwner(_sender) returns(User.UserWorkExp[]) {
        return users[_user].work;
    }

    // @description
    // sets the user work of given user
    //
    // @param User.UserWorkExp _work
    // UserWorkExp struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserWorkExp(User.UserWorkExp _work, address _user, address _sender) public isOwner(_sender) {
        users[_user].work.push(_work);
    }

    // @description
    // deletes the user work exp of given user
    //
    // @param uint _index
    // index of the work exp to be deleted
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function deleteUserWorkExp(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].work[_index].isDeleted = true;
    }

    // @description
    // gets the user skill of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserSkill
    function getUserSkill(address _user, address _sender) public view isOwner(_sender) returns(User.UserSkill) {
        return users[_user].skills;
    }

    // @description
    // sets the user skills of given user
    //
    // @param User.UserSkill _personal
    // UserSkill struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserSkills(User.UserSkill _skills, address _user, address _sender) public isOwner(_sender) {
        users[_user].skills = _skills;
    }

    // @description
    // gets the user introduction of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserIntroduction
    function getUserIntro(address _user, address _sender) public view isOwner(_sender) returns(User.UserIntroduction) {
        return users[_user].introduction;
    }

    // @description
    // sets the user introduction of given user
    //
    // @param User.UserIntroduction _personal
    // UserIntroduction struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserIntro(User.UserIntroduction _intro, address _user, address _sender) public isOwner(_sender) {
        users[_user].introduction = _intro;
    }

    // @description
    // gets the user education of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserEducation[]
    function getUserEducation(address _user, address _sender) public view isOwner(_sender) returns(User.UserEducation[]) {
        return users[_user].education;
    }

    // @description
    // sets the user education of given user
    //
    // @param User.UserEducation _personal
    // UserEducation struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserEducation(User.UserEducation _edu, address _user, address _sender) public isOwner(_sender) {
        users[_user].education.push(_edu);
    }

    // @description
    // deletes the user education of given user
    //
    // @param uint _index
    // index of the education to be deleted
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function deleteUserEducation(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].education[_index].isDeleted = true;
    }

    // @description
    // gets the user publication of given user
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    //
    // @returns User.UserPublication[]
    function getUserPublication(address _user, address _sender) public view isOwner(_sender) returns(User.UserPublication[]) {
        return users[_user].publications;
    }

    // @description
    // sets the user publication of given user
    //
    // @param User.UserPublication _personal
    // UserPublication struct
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function setUserPublication(User.UserPublication _pub, address _user, address _sender) public isOwner(_sender) {
        users[_user].publications.push(_pub);
    }

    // @description
    // deletes the user publication of given user
    //
    // @param uint _index
    // index of the publication to be deleted
    //
    // @param address _user
    // address of the user
    // 
    // @param address _sender
    // address of the sender of the main request to Blockvitae contract
    function deleteUserPublication(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].publications[_index].isDeleted = true;
    }

    // @description
    // check if the given address _user exists
    // 
    // @param address _user
    // address of the user to be checked
    //
    // @param address _sender
    // address of the sender - the owner of the contract
    function isExists(address _user, address _sender) public view isOwner(_sender) returns(bool) {
        return users[_user].exists;
    }

    // @description
    // increments the total count of the users on every sign up
    //
    // @param address _sender
    // address of the sender of the function call - the owner of the contract
    function incrementTotalUsers(address _sender) public isOwner(_sender) {
        totalUsers++;
    }

    // @description
    // creates the existance of the user
    // 
    // @param address _user
    // address of the user
    function persistUser(address _user, address _sender) public isOwner(_sender) {
        users[_user].exists = true;
        users[_user].owner = _user;
    }
}
