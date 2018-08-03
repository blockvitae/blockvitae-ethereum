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
import "./DBGetter.sol";
import "./DB.sol";

contract BlockvitaeGetter is Blockvitae {

	Blockvitae private blockvitae;

	DBGetter private dbGetter;

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
		dbGetter = _dbGetter;
		blockvitae = _blockvitae;
	}

	// check for the owner
    modifier isOwner(address _sender) {
        require(blockvitae.owner() == _sender);
        _;
    }

	// @description
	// gets count of total education added
	//
	// @param address _user
	// address of the user who's data is to be searched
	//
	// @return uint
	// count of the total education for the given user
	function getEducationCount(address _user)
	public
	view
	returns(uint) {
			return dbGetter.findUserEducation(_user).length;
	}

	// @description
	// gets the user education with the given index for the given user
	//
	// @param address _user
	// address of the user who's education is to be searched
	//
	// @param uint _index
	// index of the education to be searched
	//
	// @return (string, string, string, string, string, bool)
	// organization, level, dateStart, dateEnd
	// and description of the education with given index
	function getUserEducation(address _user, uint _index)
	public
	view
	returns(string, string, string, string, string, bool) {
			User.UserEducation[] memory education = dbGetter.findUserEducation(_user);

			return (education[_index].organization, education[_index].level, 
			education[_index].dateStart, education[_index].dateEnd, 
			education[_index].description, education[_index].isDeleted);
	}

	// @description
	// gets count of total publications added
	//
	// @param address _user
	// address of the user who's data is to be searched
	//
	// @return uint
	// count of the total publication for the given user
	function getPublicationCount(address _user)
	public
	view
	returns(uint) {
			return dbGetter.findUserPublication(_user).length;
	}

	// @description
	// gets the user publication with the given index for the given user
	//
	// @param address _user
	// address of the user who's publication is to be searched
	//
	// @param uint _index
	// index of the publication to be searched
	//
	// @return (string, string, string, bool)
	// title, url, description & isDeleted of the publication with given index
	function getUserPublication(address _user, uint _index)
	public
	view
	returns(string, string, string, bool) {
			User.UserPublication[] memory publication = dbGetter.findUserPublication(_user);

			return (publication[_index].title, publication[_index].url,
			publication[_index].description, publication[_index].isDeleted);
	}

	// @description
	// gets the array of skills of the user
	//
	// @param address _user
	// address of the user who's data is to be searched
	//
	// @return bytes32[]
	// array of skills of the user with given address
	function getUserSkills(address _user) public view returns(bytes32[]) {
			return dbGetter.findUserSkill(_user).skills;
	}

	// @description
	// gets the string of introduction of the user
	//
	// @param address _user
	// address of the user who's data is to be searched
	//
	// @return string
	// introduction of the user with given address
	function getUserIntroduction(address _user) public view returns(string) {
			return dbGetter.findUserIntroduction(_user).introduction;
	}

	// @description
	// Solidity doesn't allow to return array of strings
	// Therefore, get count of projects first and
	// then get each project one at a time from front end
	//
	// @param address _user
	// address of the user who's data is to be searched
	//
	// @return uint
	// count of the total projects for the given user
	function getProjectCount(address _user) 
	public 
	view 
	returns(uint) {
			return dbGetter.findUserProject(_user).length;
	}

	// @description
	// gets the user project with the given index for the given user
	//
	// @param address _user
	// address of the user who's projects are to be searched
	//
	// @param uint _index
	// index of the project to be searched
	//
	// @return (string, string, string, string, bool)
	// name, short description, description and url of the project with given index
	function getUserProject(address _user, uint _index)
	public
	view
	returns(string, string, string, string, bool) {
			User.UserProject[] memory projects = dbGetter.findUserProject(_user);
	
			return (projects[_index].name, projects[_index].shortDescription, 
			projects[_index].description, projects[_index].url,
			projects[_index].isDeleted);
	}

	// @description
	// gets count of total work experiences added
	//
	// @param address _user
	// address of the user who's data is to be searched
	//
	// @return uint
	// count of the total work exp for the given user
	function getWorkExpCount(address _user) 
	public 
	view 
	returns(uint) {
			return dbGetter.findUserWorkExp(_user).length;
	}

	// @description
	// gets the user work exp with the given index for the given user
	//
	// @param address _user
	// address of the user who's work exp are to be searched
	//
	// @param uint _index
	// index of the work exp to be searched
	//
	// @return (string, string, string, string, string, bool, bool)
	// company, position, dateStart, dateEnd
	// and description of the work exp with given index
	function getUserWorkExp(address _user, uint _index)
	public
	view
	returns(string, string, string, string, string, bool, bool) {
			User.UserWorkExp[] memory work = dbGetter.findUserWorkExp(_user);
	
			return (work[_index].company, work[_index].position, work[_index].dateStart, 
			work[_index].dateEnd, work[_index].description, 
			work[_index].isWorking, work[_index].isDeleted);
	}

	// @description 
	// returns UserDetail struct values
	// for the given address if user exists
	//
	// @param address _user 
	// address of the user for which UserDetail is 
	// to be searched
	//
	// @return (string, bytes32, string, string, string, string)
	// array of strings containing values of 
	// UserDetail struct in the respective order
	function getUserDetail(address _user)  
	public 
	view
	returns(string, bytes32, string, string, string, string) 
	{
			// find the user details
			User.UserDetail memory personal = dbGetter.findUserDetail(_user);
			// return
			return (personal.fullName, personal.userName, personal.imgUrl, 
			personal.email, personal.location, personal.description);
	}

	// @description 
	// returns UserSocial struct values
	// for the given address if user exists
	//
	// @param address _user 
	// address of the user for which UserSocial is 
	// to be searched
	//
	// @return (string, string, string, string, string, string, string, string)
	// array of strings containing values of 
	// UserSocial struct in the respective order
	function getUserSocial(address _user)  
	public 
	view
	returns(string, string, string, string, string, string, string, string) 
	{
			// find the user details
			User.UserSocial memory social = dbGetter.findUserSocial(_user);

			// return
			return (social.websiteUrl, social.twitterUrl, social.fbUrl, social.githubUrl, social.dribbbleUrl, 
					social.linkedInUrl, social.behanceUrl, social.mediumUrl);
	}

	// @description
	// finds the address the given userName
	//
	// @param string _userName
	// userName of the user who's address is to be searched
	//
	// @return address
	// address of the user with given userName
	function getAddrForUserName(bytes32 _userName)
	public
	view
	returns(address) 
	{
			return dbGetter.findAddrForUserName(_userName);
	}

	// @description
	// Checks if the given username is available or taken
	//
	// @param string _userName
	// username to be checked
	//
	// @return bool
	// true if username is available else false
	function isUsernameAvailable(bytes32 _userName)
	public
	view
	returns(bool)
	{
			return dbGetter.usernameExists(_userName);
	}

	// @description
	// gets the total number of users registered so far
	//
	// @return uint
	// count of users registered so far
	function getTotalUsers() public view isOwner(msg.sender) returns(uint) {
			return db.totalUsers();
	}
}