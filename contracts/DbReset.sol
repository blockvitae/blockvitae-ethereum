pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2; // experimental

import "./DB.sol";

contract DbReset {

  constructor (DB _db) public {
    // this contract deployed at last removes db as its owner to avoid any
    // direct public access to DB contracts
    _db.setOwner(address(this));
    _db.removeOwner(_db, address(this));
  }
}