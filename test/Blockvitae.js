/**
 * This file tests all the code inside Blockvitae contract
 * using unit tests
 */

// import contract
let BlockvitaeContract = artifacts.require("./Blockvitae.sol");

contract("Blockvitae", (accounts) => {

    // global variables
    let blockvitae = '';

    // run beforeEach before each "it" call
    beforeEach(async () => {
        blockvitae = await BlockvitaeContract.deployed();
    });

    // check if the contract is successfully deployed
    it("contract deployed successfully", async () => {
        // get the owner
        let owner = await blockvitae.owner();
        assert.equal(owner, accounts[0]);
    });

    // check if user gets created
    it("user created successfully", async () => {
        let fullName = "John";
        let userName = "JDoe";
        // CC0 license image pexels.com
        let imgUrl = "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg";
        let email = "john_doe@gmail.com";
        let location = "Boston, MA";
        let description = "Full Stack Developer";

        // save in contract
       await blockvitae.createUserDetail (
            fullName,
            userName,
            imgUrl,
            email,
            location,
            description
        );

        // get the values
        let personal = await blockvitae.getUserDetail(accounts[0]);

        // assert statements
        assert(fullName, personal[0]);
        assert(userName, personal[1]);
        assert(imgUrl, personal[2]);
        assert(email, personal[3]);
        assert(location, personal[4]);
        assert(description, personal[5]);
    });

    // check for update owner
    it("owner updated successfully", async () => {
        // old owner
        let oldOwner = await blockvitae.owner();

        // change owner
        await blockvitae.setOwner(accounts[1]);

        let newOwner = await blockvitae.owner();

        assert(oldOwner, accounts[0]);
        assert(newOwner, accounts[1]);
    });

    // check for user social 
    it("user social accounts added successfully", async () => {
        let websiteUrl = "https://sidharthmalhotra.in";
        let twitterUrl = "https://twitter.com/johndoe";
        let fbUrl = "https://facebook.com/johndoe";
        let githubUrl = "https://github.com/johndoe";
        let dribbbleUrl = "";
        let linkedUrl = "https://linkedin.com/in/johndoe";
        let behanceUrl = "";
        let mediumUrl = "https://medium.com/@johndoe";

        // create userSocial
        await blockvitae.createUserSocial(
            websiteUrl,
            twitterUrl,
            fbUrl,
            githubUrl,
            dribbbleUrl,
            linkedUrl,
            behanceUrl,
            mediumUrl
        );

        // get values
        let social = await blockvitae.getUserSocial(accounts[0]);

        // assert statements
        assert(websiteUrl, social[0]);
        assert(twitterUrl, social[1]);
        assert(fbUrl, social[2]);
        assert(githubUrl, social[3]);
        assert.lengthOf(dribbbleUrl, social[4].length);
        assert(linkedUrl, social[5]);
        assert.lengthOf(behanceUrl, social[6].length);
        assert(mediumUrl, social[7]);
    });

    // check for user projects
    it("user projects added successfully", async () => {
        // projects
        let name = ["Discover", "Blockvitae"];
        let shortDescription = ["Travellers meet locals", "World's first blockchain resume"];
        let description = ["A web application to connect tourists with locals for city tours",
                            "A blockchain based curriculum viate"];
        let url = ["https://discoverapp.com", "https://blockvitae.com"];
        let deleted = [true, false];

        // create project 1
        await blockvitae.createUserProject(name[0], shortDescription[0], 
            description[0], url[0], deleted[0]);

        // create project 2
        await blockvitae.createUserProject(name[1],shortDescription[1], 
            description[1], url[1], deleted[1]);

        // get projects count 
        let count = await blockvitae.getProjectCount(accounts[0]);

        // get project details for each project index
        for (let i = 0; i < count.toNumber(); i++) {
             // get project 1
            let project = await blockvitae.getUserProject(accounts[0], i);
            
            // assert statements
            assert(name[i], project[0]);
            assert(shortDescription[i], project[1]);
            assert(description[i], project[2]);
            assert(url[i], project[3]);

            if (i == 0) 
                assert.isTrue(project[4]);
            else    
                assert.isFalse(project[4]);
        }
    });

    // project deleted
    it("project deleted successfully", async () => {
        
        let projectBeforeDelete = await blockvitae.getUserProject(accounts[0], 1);
        
        // delete second project
        await blockvitae.deleteUserProject(1);

        let projectAfterDelete = await blockvitae.getUserProject(accounts[0], 1);

        assert.isFalse(projectBeforeDelete[4]);
        assert.isTrue(projectAfterDelete[4]);
    });

    // check for user work exp
    it("user work experience added successfully", async () => {
        // work exp
        let company = ["Statusbrew", "Web Bakerz"];
        let description = ["Work with a dedicated team of 25 members from 5 different nations", 
                            "Managed and built marketing teams"];
        let position = ["Backend Engineer", "CMO"];
        let dateStart = ["2016-12-20", "2018-01-01"];
        let dateEnd = ["2017-08-18", ""];
        let isWorking = [false, true];
        let deleted = [true, false];

        // create exp 1
        await blockvitae.createUserWorkExp(
            company[0],
            position[0],
            dateStart[0],
            dateEnd[0],
            description[0],
            isWorking[0],
            deleted[0]
        );

        // create exp 2
        await blockvitae.createUserWorkExp(
            company[1],
            position[1],
            dateStart[1],
            dateEnd[1],
            description[1],
            isWorking[1],
            deleted[1]
        );

        // get work exp count 
        let count = await blockvitae.getWorkExpCount(accounts[0]);

        // get work exp details for each index
        for (let i = 0; i < count.toNumber(); i++) {
             // get project 1
            let work = await blockvitae.getUserWorkExp(accounts[0], i);
        
            // assert statements
            assert(company[i], work[0]);
            assert(position[i], work[1]);
            assert(dateStart[i], work[2]);
            assert(description[i], work[4]);

            if (i === 0) {
                assert.isFalse(work[5]);
                assert.isTrue(work[6]);
                assert(dateEnd[i], work[3]);
            }
            else {
                assert.isTrue(work[5]);
                assert.isFalse(work[6]);
            }
        }
    });

    // delete work exp
    it("work experience deleted successfully", async () => {
        let workExpBeforeDelete = await blockvitae.getUserWorkExp(accounts[0], 1);

        // delete work exp
        await blockvitae.deleteUserWorkExp(1);

        let workExpAfterDelete = await blockvitae.getUserWorkExp(accounts[0], 1);

        assert.isFalse(workExpBeforeDelete[6]);
        assert.isTrue(workExpAfterDelete[6]);
    });

    // check for user skills
    it("user skills added successfully", async () => {
        let skills = ["Php", "ETH Smart Contracts", "MySQL", 
            "Leadership", "Truffle", "Go", "Java Spring Boot"];

        // insert skills
        await blockvitae.createUserSkill(skills);

        // retrieve skills
        let savedSkills = await blockvitae.getUserSkills(accounts[0]);
        
        // convert bytes to Utf8
        savedSkills = savedSkills.map(skill => web3.toUtf8(skill));

        // assert statements
        for (let i = 0; i < savedSkills.length; i++) {
            assert(skills[i], savedSkills[i]);
        }
    });

     // check for user education
     it("user education added successfully", async () => {
        // education
        let organization = ["Northeastern University", "NYU"];
        let description = ["Head of NeU Cultural Committee", 
                            "Captain of NYU Basketball team"];
        let level = ["Bachelors of Science", "Master of Science"];
        let dateStart = ["2013-12-20", "2017-01-01"];
        let dateEnd = ["2017-08-18", "2019-06-15"];
        let deleted = [false, true];

        // create edu 1
        await blockvitae.createUserEducation(
            organization[0],
            level[0],
            dateStart[0],
            dateEnd[0],
            description[0],
            deleted[0]
        );

        // create edu 2
        await blockvitae.createUserEducation(
            organization[1],
            level[1],
            dateStart[1],
            dateEnd[1],
            description[1],
            deleted[1]
        );

        // get edu count 
        let count = await blockvitae.getEducationCount(accounts[0]);

        // get edu details for each index
        for (let i = 0; i < count.toNumber(); i++) {
             // get project 1
            let education = await blockvitae.getUserEducation(accounts[0], i);
        
            // assert statements
            assert(organization[i], education[0]);
            assert(level[i], education[1]);
            assert(dateStart[i], education[2]);
            assert(dateEnd[i], education[3]);
            assert(description[i], education[4]);

            if (i === 0)
                assert.isFalse(education[5])
            else
                assert.isTrue(education[5])
        }
    });

      // delete work exp
      it("education deleted successfully", async () => {
        let educationBeforeDelete = await blockvitae.getUserEducation(accounts[0], 0);

        // delete work exp
        await blockvitae.deleteUserEducation(0);

        let educationAfterDelete = await blockvitae.getUserEducation(accounts[0], 0);

        assert.isFalse(educationBeforeDelete[5]);
        assert.isTrue(educationAfterDelete[5]);
    });


    // username updated successfully
    it("username updated successfully", async () => {
        let fullName = "John";
        let userName = "JDoe001";
        // CC0 license image pexels.com
        let imgUrl = "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg";
        let email = "john_doe@gmail.com";
        let location = "Boston, MA";
        let description = "Full Stack Developer";

        // get the values
        let personalOld = await blockvitae.getUserDetail(accounts[0]);

        // assert statements
        assert(userName, personalOld[1]);

        // save in contract
       await blockvitae.createUserDetail (
            fullName,
            userName,
            imgUrl,
            email,
            location,
            description
        );

        // get the values
        let personal = await blockvitae.getUserDetail(accounts[0]);
       
        // assert statements
        assert(userName, personal[1]);
    });

    // get address for given userName
    it("address for given userName", async () => {
        let userName = "JDoe001";

        // get address from userName
        let addr = await blockvitae.getAddrForUserName(userName);

        assert(addr, accounts[0]);
    });

    // check if username exits
    it("username existance check", async () => {
        let userName = "JDoe001";
        let userName2 = "JDoe002";

        // check if username exists
        let exists = await blockvitae.isUsernameAvailable(userName);
        let exists2 = await blockvitae.isUsernameAvailable(userName2);

        assert.isFalse(exists);
        assert.isTrue(exists2);
    });

    // add introduction
    it("introduction added successfully", async () => {
        let introduction = "This is Blockvitae";

        // Insert to Blockchain
        await blockvitae.createUserIntroduction(introduction);

        // check introduction
        let intro = await blockvitae.getUserIntroduction(accounts[0]);

        assert(introduction, intro);
    });
});