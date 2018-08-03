/**
 * This contract acts as a controller for front-end
 * requests. The DB file is separate incase, solidity adds
 * functionality to return structs. In that case, only
 * this contract needs to be redeployed and data migration
 * will not be needed as the data is stored in DB.sol
 * contract.
 */
pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2; // experimental

// imports
import "./Blockvitae.sol";
import "./DB.sol";

// @title Blockvitae for CV
contract BlockvitaeInsert is Blockvitae {

    Blockvitae private blockvitae;

    DB private db;

    // @Reference: 
	// http://solidity.readthedocs.io/en/latest/contracts.html#arguments-for-base-constructors
	constructor(DB _db, DBInsert _dbInsert, DBGetter _dbGetter, DBDelete _dbDelete, Blockvitae _blockvitae)
	Blockvitae(_db, _dbInsert, _dbGetter, _dbDelete) 
    public {
        // set this contract as the owner of DB contract
        // to avoid any external calls to DB contract
        // All calls to DB contract should pass through this
        // contract
        _db.setOwner(address(this));
        db = _db;
        blockvitae = _blockvitae;
    }

    // checks if the sender address has been registered before or not
    modifier newAccount() {
        require(!db.isExists(msg.sender, address(this)));
        _;
    }

    // check for the owner
    modifier isOwner(address _sender) {
        require(blockvitae.owner() == _sender);
        _;
    }

    // if user is whitelisted to create account
    modifier isWhitelisted() {
        require(blockvitae.whitelist(msg.sender) || blockvitae.allWhitelisted());
        _;
    }

    // @description
    // Change Owner function incase Blockviate is redeployed
    // old Blockviate should be able to update the owner to new 
    // Blockviate.
    //
    // @param address _owner
    // address of the new owner 
    function setOwnerBlockvitae(address _owner) public isOwner(msg.sender) {
       blockvitae.setOwner(_owner, msg.sender);
    }

    // @description
    // add user to whitelist so that the given user can create account
    //
    // @param address _user
    // address of the user
    function addToWhitelist(address _user) public isOwner(msg.sender) {
        blockvitae.addToWhiteList(_user, msg.sender);
    }

    // @description
    // removes the user from the whitelist and blocks user access
    //
    // @param address _user
    // address of the user
    function removeFromWhitelist(address _user) public isOwner(msg.sender) {
        blockvitae.removeFromWhiteList(_user, msg.sender);
    }

    // @description
    // anyone can create account
    function setAllWhitelisted() public isOwner(msg.sender) {
        blockvitae.setAllWhitelist(msg.sender);
    }

    // @description
    // creates UserDetail struct
    //
    // @param string _fullName 
    // full name of the user
    //
    // @param bytes32 _userName 
    // username of the user
    //
    // @param string _imgUrl 
    // profile image url of the user
    //
    // @param string _email 
    // email of the user
    //
    // @param string _location
    // (City, State) of the user
    //
    // @param string _description
    // One line descriprion of the user
    function createUserDetail(
        string _fullName,
        bytes32 _userName,
        string _imgUrl,
        string _email,
        string _location,
        string _description
    )
    public
    addressNotZero
    isWhitelisted
    newAccount
    {
        // insert into the database
        dbInsert.insertUserDetail(User.setUserDetail(
            _fullName,
            _userName,
            _imgUrl,
            _email,
            _location,
            _description), msg.sender);
    }

    // @description
    // updates UserDetail struct for
    // existing user
    //
    // @param string _fullName 
    // full name of the user
    //
    // @param bytes32 _userName 
    // username of the user
    //
    // @param string _imgUrl 
    // profile image url of the user
    //
    // @param string _email 
    // email of the user
    //
    // @param string _location
    // (City, State) of the user
    //
    // @param string _description
    // One line descriprion of the user
    function updateUserDetail(
        string _fullName,
        bytes32 _userName,
        string _imgUrl,
        string _email,
        string _location,
        string _description
    )
    public
    addressNotZero
    isWhitelisted
    userExists
    {
        // insert into the database
        dbInsert.insertUserDetail(User.setUserDetail(
            _fullName,
            _userName,
            _imgUrl,
            _email,
            _location,
            _description), msg.sender);
    }

    // @description
    // create UserSocial struct and insers in DB
    // 
    // @param string _websiteUrl
    // personal website url
    //
    // @param string _twitterUrl
    // twitter url of the user
    //
    // @param string _fbUrl
    // facebook url of the user
    //
    // @param string _githubUrl
    // github url of the user
    //
    // @param string _linkedInUrl
    // linked in url of the user
    //
    // @param string _behanceUrl
    // behance url of the user
    //
    // @param string _mediumUrl
    // medium url of the user
    function createUserSocial(
        string _websiteUrl,
        string _twitterUrl,
        string _fbUrl,
        string _githubUrl,
        string _dribbbleUrl,
        string _linkedInUrl,
        string _behanceUrl,
        string _mediumUrl
    )
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        // insert into the database
        dbInsert.insertUserSocial(User.setUserSocial(
            _websiteUrl,
            _twitterUrl,
            _fbUrl,
            _githubUrl,
            _dribbbleUrl,
            _linkedInUrl,
            _behanceUrl,
            _mediumUrl), msg.sender);
    }

    // @description
    // creates UserProject struct and insert in DB
    //
    // @param string _name
    // name of the project
    //
    // @param string _shortDescription
    // One line description of the project
    //
    // @param string _description 
    // description of the project
    //
    // @param bool _isDeleted
    // true if the current record has been deleted by the user
    //
    // @param string _url
    // url of the project
    function createUserProject(
        string _name,
        string _shortDescription,
        string _description,
        string _url,
        bool _isDeleted
    )
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        // insert into the database
        dbInsert.insertUserProject(User.setUserProject(
            _name,
            _shortDescription,
            _description,
            _url,
            _isDeleted), msg.sender);
    }

    // @description
    // creates UserPublication struct and insert in DB
    //
    // @param string _title
    // title of the paper
    //
    // @param string _url
    // url of the paper
    //
    // @param string _description 
    // description of the paper
    //
    // @param bool _isDeleted
    // true if the current record has been deleted by the user
    function createUserPublication(
        string _title,
        string _url,
        string _description,
        bool _isDeleted
    )
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        // insert into the database
        dbInsert.insertUserPublication(User.setUserPublication(
            _title,
            _url,
            _description,
            _isDeleted), msg.sender);
    }

    // @description
    // creates UserWorkExp struct and inserts in DB
    //
    // @param string _company
    // name of the company or organization
    //
    // @param string _position
    // position held in the given company
    //
    // @param string _dateStart
    // start date of the job
    //
    // @param string _dateEnd
    // end date of the job
    //
    // @param string _description
    // description of the work experience
    //
    // @param bool _isDeleted
    // true if the current record has been deleted by the user
    //
    // @param bool _isWorking
    // true if user still works here
    function createUserWorkExp(
        string _company,
        string _position,
        string _dateStart,
        string _dateEnd,
        string _description,
        bool _isWorking,
        bool _isDeleted
    )
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        // insert in to database
        dbInsert.insertUserWorkExp(User.setUserWorkExp(
            _company,
            _position,
            _dateStart,
            _dateEnd,
            _description,
            _isWorking,
            _isDeleted), msg.sender);
    }

    // @description
    // creates UserSkill struct and inserts in DB
    //
    // @param bytes32[] _skills
    // array of skills
    function createUserSkill(bytes32[] _skills) 
    public 
    addressNotZero 
    userExists
    isWhitelisted {
        // insert into DB
        dbInsert.insertUserSkill(User.setUserSkill(_skills), msg.sender);
    }

    // @description
    // creates UserIntroduction struct and inserts in DB
    //
    // @param string _introduction
    // introduction of the user
    function createUserIntroduction(string _introduction) 
    public 
    addressNotZero
    userExists
    isWhitelisted {
        // insert into DB
        dbInsert.insertUserIntroduction(User.setUserIntroduction(_introduction), msg.sender);
    }

    // @description
    // creates UserEducation struct and inserts in DB
    //
     // @param string _organization
    // name of the organization
    //
    // @param string _level
    // education level held in the given organization
    //
    // @param string _dateStart
    // start date of the education
    //
    // @param string _dateEnd
    // end date of the education
    //
    // @param string _description
    // description of the education
    //
    // @param bool _isDeleted
    // true if the current record has been deleted by the user
    //
    // @return UserEducation
    // UserEducation struct for the given values
    function createUserEducation(
        string _organization,
        string _level,
        string _dateStart,
        string _dateEnd,
        string _description,
        bool _isDeleted 
    )
    public
    addressNotZero
    userExists
    isWhitelisted
    {
        // insert in the database
        dbInsert.insertUserEducation(User.setUserEducation(
            _organization,
            _level,
            _dateStart,
            _dateEnd,
            _description,
            _isDeleted), msg.sender);
    }
}


