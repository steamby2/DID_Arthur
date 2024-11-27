// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // Importation pour utiliser les tests Remix
import "../contracts/DIDContract.sol";
import "remix_accounts.sol"; // Importation pour accéder aux comptes de test

contract DIDContractTest {
    DIDContract didContract;
    address userAddress = address(0x123); // Adresse utilisateur pour les tests

    /// #sender: account-0
    function beforeAll() public {
        // Déployer le contrat
        didContract = new DIDContract();

        // Vérifier que l'administrateur (account-0) a le rôle approprié
        address admin1 = TestsAccounts.getAccount(0);
        Assert.equal(
            didContract.hasRole(didContract.CONSTRUCTOR_ADMIN_ROLE(), admin1),
            true,
            unicode"L'administrateur doit avoir le rôle CONSTRUCTOR_ADMIN_ROLE"
        );
    }

    /// #sender: account-0
    function testCreateDID() public {
        string memory did = "did:example:123";

        // Créer un DID pour l'utilisateur
        didContract.createDID(did, "Test Document", "Alice", "alice@example.com", userAddress);

        // Vérifier que le DID a été créé correctement
        (string memory document, string memory name, string memory email, address owner) = didContract.verifyDID(did);
        Assert.equal(document, "Test Document", unicode"Le document DID doit être 'Test Document'");
        Assert.equal(name, unicode"Alice", unicode"Le nom doit être 'Alice'");
        Assert.equal(email, "alice@example.com", unicode"L'email doit être 'alice@example.com'");
        Assert.equal(owner, userAddress, unicode"Le propriétaire doit être l'utilisateur spécifié");

        // Vérifier que l'utilisateur a reçu le rôle USER_ROLE
        Assert.equal(
            didContract.hasRole(didContract.USER_ROLE(), userAddress),
            true,
            unicode"L'utilisateur doit avoir le rôle USER_ROLE après la création du DID"
        );
    }

    /// #sender: account-1
    function testUpdateDID() public {
        string memory did = "did:example:123";

        // Transférer le DID à account-1 pour simuler la mise à jour par un nouveau propriétaire
        /// #sender: account-0
        didContract.transferDID(did, TestsAccounts.getAccount(1));

        // Mettre à jour le DID en tant que nouveau propriétaire
        didContract.updateDID(did, "Updated Document");

        // Vérifier que la mise à jour a été appliquée
        (string memory document, , , ) = didContract.verifyDID(did);
        Assert.equal(document, "Updated Document", unicode"Le document DID doit être mis à jour");
    }

    /// #sender: account-0
    function testTransferDID() public {
        string memory did = "did:example:123";
        address newOwner = TestsAccounts.getAccount(2);

        // Transférer le DID à un nouvel utilisateur
        didContract.transferDID(did, newOwner);

        // Vérifier que le transfert a été effectué
        (, , , address owner) = didContract.verifyDID(did);
        Assert.equal(owner, newOwner, unicode"Le propriétaire doit être le nouvel utilisateur");
    }
}
