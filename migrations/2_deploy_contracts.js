/**
 * This file deploys all the compiled smart contracts
 */
let Blockvitae = artifacts.require("./Blockvitae.sol");
let BlockvitaeInsert = artifacts.require("./BlockvitaeInsert.sol");
let BlockvitaeGetter = artifacts.require("./BlockvitaeGetter.sol");
let BlockvitaeDelete = artifacts.require("./BlockvitaeDelete.sol");
let User = artifacts.require("./User.sol");
let Db = artifacts.require("./DB.sol");
let DbGetter = artifacts.require("./DbGetter.sol");
let DbDelete = artifacts.require("./DbDelete.sol");
let DbInsert = artifacts.require("./DbInsert.sol");

module.exports = function (deployer) {
    // deploy contracts
    deployer
        .deploy(User)
        .then(() => {
            deployer.link(User, [Db, Blockvitae]);
            // return
            return deployer
                .deploy([DbGetter, DbDelete, DbInsert])
                .then(() => {
                   return deployer.deploy(Blockvitae, DbInsert.address, DbGetter.address, DbDelete.address)
                   .then(() => {
                    return deployer.deploy([
                        [BlockvitaeGetter, DbInsert.address, DbGetter.address, DbDelete.address],
                        [BlockvitaeDelete, DbInsert.address, DbGetter.address, DbDelete.address],
                        [BlockvitaeInsert, DbInsert.address, DbGetter.address, DbDelete.address]]);
                   })
                });
        });
}