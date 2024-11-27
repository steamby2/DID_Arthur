// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DIDContract is AccessControl {
    bytes32 public constant CONSTRUCTOR_ADMIN_ROLE = keccak256("CONSTRUCTOR_ADMIN_ROLE");
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    struct DID {
        string didDocument;
        string name;
        string email;
        address owner;
    }

    mapping(string => DID) private dids;

    event DIDCreated(string did, address owner);
    event DIDUpdated(string did, string newDidDocument);
    event UserInfoUpdated(string did, string name, string email);

    constructor() {
        // Adresses définies statiquement
        address admin1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        address admin2 = 0xDC5C413A63CCecE3A99063901E7F2497b81d455a;

        // Attribution des rôles aux deux administrateurs
        _grantRole(DEFAULT_ADMIN_ROLE, admin1);
        _grantRole(CONSTRUCTOR_ADMIN_ROLE, admin1);
        _grantRole(DEFAULT_ADMIN_ROLE, admin2);
        _grantRole(CONSTRUCTOR_ADMIN_ROLE, admin2);
    }

    // Fonction pour créer un DID pour une adresse utilisateur spécifiée
    function createDID(
        string memory _did,
        string memory _didDocument,
        string memory _name,
        string memory _email,
        address userAddress // Nouvelle adresse propriétaire
    ) public onlyRole(CONSTRUCTOR_ADMIN_ROLE) {
        require(dids[_did].owner == address(0), "DID already exists");
        
        // Associer le DID à l'utilisateur spécifié
        dids[_did] = DID(_didDocument, _name, _email, userAddress);
        
        // Attribuer le rôle d'utilisateur à l'adresse
        _grantRole(USER_ROLE, userAddress);

        emit DIDCreated(_did, userAddress);
    }

    function updateDID(string memory _did, string memory _newDidDocument) public {
        require(dids[_did].owner == msg.sender, "Not the owner of the DID");
        dids[_did].didDocument = _newDidDocument;
        emit DIDUpdated(_did, _newDidDocument);
    }

    function updateUserInfo(string memory _did, string memory _name, string memory _email) public {
        require(dids[_did].owner == msg.sender, "Not the owner of the DID");
        dids[_did].name = _name;
        dids[_did].email = _email;
        emit UserInfoUpdated(_did, _name, _email);
    }

    function verifyDID(string memory _did) public view onlyRole(VERIFIER_ROLE) returns (string memory, string memory, string memory, address) {
        DID memory didData = dids[_did];
        return (didData.didDocument, didData.name, didData.email, didData.owner);
    }

    function addVerifier(address verifier) public onlyRole(CONSTRUCTOR_ADMIN_ROLE) {
        grantRole(VERIFIER_ROLE, verifier);
    }

    function changeSuperAdmin(address newAdmin) public onlyRole(CONSTRUCTOR_ADMIN_ROLE) {
        grantRole(CONSTRUCTOR_ADMIN_ROLE, newAdmin);
        revokeRole(CONSTRUCTOR_ADMIN_ROLE, msg.sender);
    }

    function transferDID(string memory _did, address newOwner) public onlyRole(CONSTRUCTOR_ADMIN_ROLE) {
        require(dids[_did].owner != address(0), "DID does not exist");
        require(newOwner != address(0), "New owner address is invalid");
        dids[_did].owner = newOwner;
    }
}
