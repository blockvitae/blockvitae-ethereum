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
    function removeOwner(address _blockvitae, address _sender) public isOwner(_sender){
        owners[_blockvitae] = false;
    }

    function getUserDetail(address _user, address _sender) public view isOwner(_sender) returns(User.UserDetail){
        return users[_user].personal;
    }

    function setUserDetail(User.UserDetail _personal, address _user, address _sender) public isOwner(_sender) {
        users[_user].personal = _personal;
    }

    function getUserNameAddr(bytes32 _user, address _sender) public view isOwner(_sender) returns(address) {
        return userNames[_user];
    }

    function setUserNameAddr(bytes32 _userName, address _user, address _sender) public isOwner(_sender) {
        userNames[_userName] = _user;
    }

    function getUserSocial(address _user, address _sender) public view isOwner(_sender) returns(User.UserSocial) {
        return users[_user].social;
    }

    function setUserSocial(User.UserSocial _social, address _user, address _sender) public isOwner(_sender) {
        users[_user].social = _social;
    }

    function getUserProject(address _user, address _sender) public view isOwner(_sender) returns(User.UserProject[]) {
        return users[_user].projects;
    }

    function setUserProject(User.UserProject _project, address _user, address _sender) public isOwner(_sender) {
        users[_user].projects.push(_project);
    }

    function deleteUserProject(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].projects[_index].isDeleted = true;
    }

    function getUserWorkExp(address _user, address _sender) public view isOwner(_sender) returns(User.UserWorkExp[]) {
        return users[_user].work;
    }

    function setUserWorkExp(User.UserWorkExp _work, address _user, address _sender) public isOwner(_sender) {
        users[_user].work.push(_work);
    }

    function deleteUserWorkExp(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].work[_index].isDeleted = true;
    }

    function getUserSkill(address _user, address _sender) public view isOwner(_sender) returns(User.UserSkill) {
        return users[_user].skills;
    }

    function setUserSkills(User.UserSkill _skills, address _user, address _sender) public isOwner(_sender) {
        users[_user].skills = _skills;
    }

    function getUserIntro(address _user, address _sender) public view isOwner(_sender) returns(User.UserIntroduction) {
        return users[_user].introduction;
    }

    function setUserIntro(User.UserIntroduction _intro, address _user, address _sender) public isOwner(_sender) {
        users[_user].introduction = _intro;
    }

    function getUserEducation(address _user, address _sender) public view isOwner(_sender) returns(User.UserEducation[]) {
        return users[_user].education;
    }

    function setUserEducation(User.UserEducation _edu, address _user, address _sender) public isOwner(_sender) {
        users[_user].education.push(_edu);
    }

    function deleteUserEducation(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].education[_index].isDeleted = true;
    }

    function getUserPublication(address _user, address _sender) public view isOwner(_sender) returns(User.UserPublication[]) {
        return users[_user].publications;
    }

    function setUserPublication(User.UserPublication _pub, address _user, address _sender) public isOwner(_sender) {
        users[_user].publications.push(_pub);
    }

    function deleteUserPublication(uint _index, address _user, address _sender) public isOwner(_sender) {
        users[_user].publications[_index].isDeleted = true;
    }

    function isExists(address _user, address _sender) public view isOwner(_sender) returns(bool) {
        return users[_user].exists;
    }

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
