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

    // constructor function
    constructor() public {
        totalUsers = 0;
        owners[address(this)] = true;
    } 

    // list mapping of all users
    mapping(address => User.UserMain) public users;

    // list mapping of all userNames
    mapping(string => address) public userNames;

    // check for the owner
    // address(this) gets true in the start but once all contracts
    // get deployed DbReset sets it to false to avoid any public access
    // Blockvitae Contracts becomes owner of
    // this contract
    modifier isOwner() {
        require(owners[msg.sender] || owners[address(this)]);
        _;
    }

    // @description
    // updates the current owner
    //
    // @param address _blockvitae
    // address of the Blockvitae contract
    function setOwner(address _blockvitae) public isOwner{
        owners[_blockvitae] = true;
    }

    // @description
    // updates the current owner
    //
    // @param address _blockvitae
    // address of the Blockvitae contract
    function removeOwner(address _blockvitae) public isOwner{
        owners[_blockvitae] = false;
    }

    function getUserDetail(address _user) public view isOwner returns(User.UserDetail){
        return users[_user].personal;
    }

    function setUserDetail(User.UserDetail _personal, address _user) public isOwner {
        users[_user].personal = _personal;
    }

    function getUserSocial(address _user) public view isOwner returns(User.UserSocial) {
        return users[_user].social;
    }

    function setUserSocial(User.UserSocial _social, address _user) public isOwner {
        users[_user].social = _social;
    }

    function getUserProject(address _user) public view isOwner returns(User.UserProject) {
        return users[_user].projects;
    }

    function setUserProject(User.UserProject _project, address _user) public isOwner {
        users[_user].projects.push(_project);
    }

    function getUserWorkExp(address _user) public view isOwner returns(User.UserWorkExp) {
        return users[_user].work;
    }

    function setUserWorkExp(User.UserWorkExp _work, address _user) public isOwner {
        users[_user].work.push(_work);
    }

    function getUserSkill(address _user) public view isOwner returns(User.UserSkill) {
        return users[_user].skills;
    }

    function setUserSkills(User.UserSkill _skills, address _user) public isOwner {
        users[_user].skills = _skills;
    }

    function getUserIntro(address _user) public view isOwner returns(User.UserIntroduction) {
        return users[_user].introduction;
    }

    function setUserIntro(User.UserIntroduction _intro, address _user) public isOwner {
        users[_user].introduction = _intro;
    }

    function getUserEducation(address _user) public view isOwner returns(User.UserEducation) {
        return users[_user].education;
    }

    function setUserEducation(User.UserEducation _edu, address _user) public isOwner {
        users[_user].education.push(_edu);
    }

    function getUserPublication(address _user) public view isOwner returns(User.UserPublication) {
        return users[_user].publications;
    }

    function setUserPublication(User.UserPublication _pub, address _user) public isOwner {
        users[_user].publcations.push(_pub);
    }

    function getUsers() public view isOwner {
        return users;
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
