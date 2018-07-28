/**
 * This file tests all the code inside Blockvitae contract
 * using unit tests
 */

// import contract
let BlockvitaeContract = artifacts.require("./Blockvitae.sol");
let BlockvitaeGetterContract = artifacts.require("./BlockvitaeGetter.sol");
let BlockvitaeInsertContract = artifacts.require("./BlockvitaeInsert.sol");
let BlockvitaeDeleteContract = artifacts.require("./BlockvitaeDelete.sol");

contract("Blockvitae", (accounts) => {

    // global variables
    let blockvitae = '';
    let blockvitaeInsert = '';
    let blockvitaeDelete = '';
    let blockvitaeGetter = '';

    // run beforeEach before each "it" call
    beforeEach(async () => {
        blockvitae = await BlockvitaeContract.deployed();
        blockvitaeInsert = await BlockvitaeInsertContract.deployed();
        blockvitaeDelete = await BlockvitaeDeleteContract.deployed();
        blockvitaeGetter = await BlockvitaeGetterContract.deployed();
    });

    // check if the contract is successfully deployed
    it("contract deployed successfully", async () => {
        // get the owner
        let owner = await blockvitae.owner();
        assert.equal(owner, accounts[0]);
    });

    // check for totalUsers
    it("totalUser before user creation", async () => {
        // get total users
        let totalUsers = await blockvitaeGetter.getTotalUsers();

        assert.strictEqual(totalUsers.toNumber(), 0);
    })

    // whitelist user
    it("user whitelisted", async () => {
        // whitelist user
        await blockvitaeInsert.addToWhitelist(accounts[0]);
    })

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
        await blockvitaeInsert.createUserDetail(
            fullName,
            web3.fromAscii(userName),
            imgUrl,
            email,
            location,
            description
        );

        // try creating new account with same address
        try {
            await blockvitaeInsert.createUserDetail(
                fullName,
                web3.fromAscii(userName),
                imgUrl,
                email,
                location,
                description
            );
            assert(false);
        }
        catch(e) {
            assert(e);
        }

        // get the values
        let personal = await blockvitaeGetter.getUserDetail(accounts[0]);
        
        // assert statements
        assert.strictEqual(fullName, personal[0]);
        assert.strictEqual(userName, web3.toUtf8(personal[1]));
        assert.strictEqual(imgUrl, personal[2]);
        assert.strictEqual(email, personal[3]);
        assert.strictEqual(location, personal[4]);
        assert.strictEqual(description, personal[5]);
    });

    // check for totalUsers
    it("totalUser updated successfully", async () => {
        // get total users
        let totalUsers = await blockvitaeGetter.getTotalUsers();

        assert.strictEqual(totalUsers.toNumber(), 1);
    })

    // check for update owner
    it("owner updated successfully", async () => {
        // old owner
        let oldOwner = await blockvitae.owner();

        // change owner
        await blockvitaeInsert.setOwnerBlockvitae(accounts[1]);

        let newOwner = await blockvitae.owner();

        // back to old owner
        await blockvitaeInsert.setOwnerBlockvitae(accounts[0], {from: accounts[1]});

        assert.strictEqual(oldOwner, accounts[0]);
        assert.strictEqual(newOwner, accounts[1]);
        assert.strictEqual(newOwner, accounts[1]);
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
        await blockvitaeInsert.createUserSocial(
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
        let social = await blockvitaeGetter.getUserSocial(accounts[0]);
    
        // assert statements
        assert.strictEqual(websiteUrl, social[0]);
        assert.strictEqual(twitterUrl, social[1]);
        assert.strictEqual(fbUrl, social[2]);
        assert.strictEqual(githubUrl, social[3]);
        assert.lengthOf(dribbbleUrl, social[4].length);
        assert.strictEqual(linkedUrl, social[5]);
        assert.lengthOf(behanceUrl, social[6].length);
        assert.strictEqual(mediumUrl, social[7]);
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
        await blockvitaeInsert.createUserProject(name[0], shortDescription[0],
            description[0], url[0], deleted[0]);

        // create project 2
        await blockvitaeInsert.createUserProject(name[1], shortDescription[1],
            description[1], url[1], deleted[1]);

        // get projects count 
        let count = await blockvitaeGetter.getProjectCount(accounts[0]);

        // get project details for each project index
        for (let i = 0; i < count.toNumber(); i++) {
            // get project 1
            let project = await blockvitaeGetter.getUserProject(accounts[0], i);

            // assert statements
            assert.strictEqual(name[i], project[0]);
            assert.strictEqual(shortDescription[i], project[1]);
            assert.strictEqual(description[i], project[2]);
            assert.strictEqual(url[i], project[3]);

            if (i == 0)
                assert.isTrue(project[4]);
            else
                assert.isFalse(project[4]);
        }
    });

    // project deleted
    it("project deleted successfully", async () => {

        let projectBeforeDelete = await blockvitaeGetter.getUserProject(accounts[0], 1);

        // delete second project
        await blockvitaeDelete.deleteUserProject(1);

        let projectAfterDelete = await blockvitaeGetter.getUserProject(accounts[0], 1);

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
        await blockvitaeInsert.createUserWorkExp(
            company[0],
            position[0],
            dateStart[0],
            dateEnd[0],
            description[0],
            isWorking[0],
            deleted[0]
        );

        // create exp 2
        await blockvitaeInsert.createUserWorkExp(
            company[1],
            position[1],
            dateStart[1],
            dateEnd[1],
            description[1],
            isWorking[1],
            deleted[1]
        );

        // get work exp count 
        let count = await blockvitaeGetter.getWorkExpCount(accounts[0]);

        // get work exp details for each index
        for (let i = 0; i < count.toNumber(); i++) {
            // get project 1
            let work = await blockvitaeGetter.getUserWorkExp(accounts[0], i);

            // assert statements
            assert.strictEqual(company[i], work[0]);
            assert.strictEqual(position[i], work[1]);
            assert.strictEqual(dateStart[i], work[2]);
            assert.strictEqual(description[i], work[4]);

            if (i === 0) {
                assert.isFalse(work[5]);
                assert.isTrue(work[6]);
                assert.strictEqual(dateEnd[i], work[3]);
            }
            else {
                assert.isTrue(work[5]);
                assert.isFalse(work[6]);
            }
        }
    });

    // delete work exp
    it("work experience deleted successfully", async () => {
        let workExpBeforeDelete = await blockvitaeGetter.getUserWorkExp(accounts[0], 1);

        // delete work exp
        await blockvitaeDelete.deleteUserWorkExp(1);

        let workExpAfterDelete = await blockvitaeGetter.getUserWorkExp(accounts[0], 1);

        assert.isFalse(workExpBeforeDelete[6]);
        assert.isTrue(workExpAfterDelete[6]);
    });

    // check for user skills
    it("user skills added successfully", async () => {
        let skills = ["Php", "ETH Smart Contracts", "MySQL",
            "Leadership", "Truffle", "Go", "Java Spring Boot"];

        // insert skills
        await blockvitaeInsert.createUserSkill(skills);

        // retrieve skills
        let savedSkills = await blockvitaeGetter.getUserSkills(accounts[0]);

        // convert bytes to Utf8
        savedSkills = savedSkills.map(skill => web3.toUtf8(skill));

        // assert statements
        for (let i = 0; i < savedSkills.length; i++) {
            assert.strictEqual(skills[i], savedSkills[i]);
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
        await blockvitaeInsert.createUserEducation(
            organization[0],
            level[0],
            dateStart[0],
            dateEnd[0],
            description[0],
            deleted[0]
        );

        // create edu 2
        await blockvitaeInsert.createUserEducation(
            organization[1],
            level[1],
            dateStart[1],
            dateEnd[1],
            description[1],
            deleted[1]
        );

        // get edu count 
        let count = await blockvitaeGetter.getEducationCount(accounts[0]);

        // get edu details for each index
        for (let i = 0; i < count.toNumber(); i++) {
            // get project 1
            let education = await blockvitaeGetter.getUserEducation(accounts[0], i);

            // assert statements
            assert.strictEqual(organization[i], education[0]);
            assert.strictEqual(level[i], education[1]);
            assert.strictEqual(dateStart[i], education[2]);
            assert.strictEqual(dateEnd[i], education[3]);
            assert.strictEqual(description[i], education[4]);

            if (i === 0)
                assert.isFalse(education[5]);
            else
                assert.isTrue(education[5]);
        }
    });

    // delete education
    it("education deleted successfully", async () => {
        let educationBeforeDelete = await blockvitaeGetter.getUserEducation(accounts[0], 0);

        // delete education
        await blockvitaeDelete.deleteUserEducation(0);

        let educationAfterDelete = await blockvitaeGetter.getUserEducation(accounts[0], 0);

        assert.isFalse(educationBeforeDelete[5]);
        assert.isTrue(educationAfterDelete[5]);
    });

    // check for user publication
    it("user publication added successfully", async () => {
        // education
        let title = ["Publication 1", "Publication 2"];
        let url = ["https://publication1.com",
            "https://publication2.com"];
        let description = ["Publication 1", "Publication 2"];
        let deleted = [false, true];

        // create publication 1
        await blockvitaeInsert.createUserPublication(
            title[0],
            url[0],
            description[0],
            deleted[0]
        );

        // create publication 2
        await blockvitaeInsert.createUserPublication(
            title[1],
            url[1],
            description[1],
            deleted[1]
        );

        // get edu count 
        let count = await blockvitaeGetter.getPublicationCount(accounts[0]);

        // get edu details for each index
        for (let i = 0; i < count.toNumber(); i++) {
            // get publication 1
            let publication = await blockvitaeGetter.getUserPublication(accounts[0], i);

            // assert statements
            assert.strictEqual(title[i], publication[0]);
            assert.strictEqual(url[i], publication[1]);
            assert.strictEqual(description[i], publication[2]);

            if (i === 0)
                assert.isFalse(publication[3]);
            else
                assert.isTrue(publication[3]);
        }
    });

    // delete publication
    it("publication deleted successfully", async () => {
        let publicationBeforeDelete = await blockvitaeGetter.getUserPublication(accounts[0], 0);

        // delete publication
        await blockvitaeDelete.deleteUserPublication(0);

        let publicationAfterDelete = await blockvitaeGetter.getUserPublication(accounts[0], 0);

        assert.isFalse(publicationBeforeDelete[3]);
        assert.isTrue(publicationAfterDelete[3]);
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
        let personalOld = await blockvitaeGetter.getUserDetail(accounts[0]);

        // assert statements
        assert.strictEqual("JDoe", web3.toUtf8(personalOld[1]));

        // save in contract
        await blockvitaeInsert.updateUserDetail(
            fullName,
            web3.fromAscii(userName),
            imgUrl,
            email,
            location,
            description
        );

        // get the values
        let personal = await blockvitaeGetter.getUserDetail(accounts[0]);

        // assert statements
        assert.strictEqual(userName, web3.toUtf8(personal[1]));
    });

    // get address for given userName
    it("address for given userName", async () => {
        let userName = "JDoe001";

        // get address from userName
        let addr = await blockvitaeGetter.getAddrForUserName(web3.fromAscii(userName));

        assert.strictEqual(addr, accounts[0]);
    });

    // check if username exits
    it("username existance check", async () => {
        let userName = "JDoe001";
        let userName2 = "JDoe002";

        // check if username exists
        let exists = await blockvitaeGetter.isUsernameAvailable(userName);
        let exists2 = await blockvitaeGetter.isUsernameAvailable(userName2);

        assert.isFalse(exists);
        assert.isTrue(exists2);
    });

    // add introduction
    it("introduction added successfully", async () => {
        let introduction = "This is Blockvitae";

        // Insert to Blockchain
        await blockvitaeInsert.createUserIntroduction(introduction);

        // check introduction
        let intro = await blockvitaeGetter.getUserIntroduction(accounts[0]);

        assert.strictEqual(introduction, intro);
    });
});