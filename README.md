# blockvitae-ethereum

[![Build Status](https://travis-ci.org/blockvitae/blockvitae-ethereum.svg?branch=master)](https://travis-ci.org/blockvitae/blockvitae-ethereum)

The parent respository `sidharth0094/blockvitae` has been
separated into two repositories `blockvitae/blockvitae-angular`
and `blockvitae/blockvitae-ethereum`.


## Deployment Instructions

* Clone the master branch of the latest version of the smart contracts
* Open CLI, and change the directory to the directory where files are cloned
* Download and install [Ganache GUI](https://truffleframework.com/ganache) and install it
* Run `truffle migrate` and wait till all contracts get deployed locally
* Then, `truffle test` and wait for all tests to pass
* Then to deploy to Ropsten network, run `truffle migrate --network ropsten`