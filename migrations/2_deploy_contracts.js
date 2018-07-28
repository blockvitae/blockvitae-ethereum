/**
 * This file deploys all the compiled smart contracts
 */
let Blockvitae = artifacts.require("./Blockvitae.sol");
let BlockvitaeInsert = artifacts.require("./BlockvitaeInsert.sol");
let BlockvitaeGetter = artifacts.require("./BlockvitaeGetter.sol");
let BlockvitaeDelete = artifacts.require("./BlockvitaeDelete.sol");
let User = artifacts.require("./User.sol");
let Db = artifacts.require("./DB.sol");
let DbGetter = artifacts.require("./DBGetter.sol");
let DbDelete = artifacts.require("./DBDelete.sol");
let DbInsert = artifacts.require("./DBInsert.sol");
let DbReset = artifacts.require("./DbReset.sol");

module.exports = function (deployer) {
    // deploy contracts
    deployer
        .deploy(User)
        .then(() => {
            deployer.link(User, [Db, Blockvitae]);
            // return
            return deployer
                .deploy(Db)
                .then(() => {
                    return deployer.deploy([
                        [DbDelete, Db.address],
                        [DbGetter, Db.address],
                        [DbInsert, Db.address]])
                        .then(() => {
                            return deployer.deploy(Blockvitae, Db.address, DbInsert.address, DbGetter.address, DbDelete.address)
                                .then(() => {
                                    // always deploy BlockviateInsert at the last
                                    return deployer.deploy([
                                        [BlockvitaeGetter, Db.address, DbInsert.address, DbGetter.address, DbDelete.address, Blockvitae.address],
                                        [BlockvitaeDelete, Db.address, DbInsert.address, DbGetter.address, DbDelete.address, Blockvitae.address],
                                        [BlockvitaeInsert, Db.address, DbInsert.address, DbGetter.address, DbDelete.address, Blockvitae.address]
                                    ])
                                        .then(() => {
                                            return deployer.deploy(DbReset, Db.address)
                                        })
                                })
                        });
                })
        });
}