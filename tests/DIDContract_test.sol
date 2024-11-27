// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // Importation pour utiliser les tests Remix
import "../contracts/DIDContract.sol";

contract DIDContractTest {
    DIDContract didContract;
    address adminAddress = address(this); // Adresse de l'administrateur pour le test
    address userAddress = address(0x123); // Adresse utilisateur pour les tests

    // Configuration avant chaque test
    function beforeAll() public {
        // Déployer le contrat avec l'adresse de l'administrateur
        didContract = new DIDContract(adminAddress);

        // Vérifier que l'administrateur a le rôle approprié
        Assert.equal(
            didContract.hasRole(didContract.CONSTRUCTOR_ADMIN_ROLE(), adminAddress),
            true,
            unicode"L'administrateur doit avoir le rôle CONSTRUCTOR_ADMIN_ROLE"
        );
    }

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

    function testUpdateDID() public {
        string memory did = "did:example:123";

        // Simuler une mise à jour par l'utilisateur
        try didContract.updateDID(did, "Updated Document") {
            Assert.ok(false, unicode"L'utilisateur non propriétaire ne peut pas mettre à jour le DID");
        } catch Error(string memory reason) {
            Assert.equal(reason, unicode"Not the owner of the DID", unicode"Le message d'erreur doit indiquer que l'utilisateur n'est pas le propriétaire");
        } catch {
            Assert.ok(false, "Une erreur inattendue s'est produite");
        }

        // Effectuer le transfert au testeur pour simuler la mise à jour
        didContract.transferDID(did, adminAddress);

        // Mettre à jour le DID
        didContract.updateDID(did, "Updated Document");

        // Vérifier que la mise à jour a été appliquée
        (string memory document, , , ) = didContract.verifyDID(did);
        Assert.equal(document, unicode"Updated Document", unicode"Le document DID doit être mis à jour");
    }

    function testTransferDID() public {
        string memory did = "did:example:123";
        address newOwner = address(0x456);

        // Transférer le DID à un nouvel utilisateur
        didContract.transferDID(did, newOwner);

        // Vérifier que le transfert a été effectué
        (, , , address owner) = didContract.verifyDID(did);
        Assert.equal(owner, newOwner, unicode"Le propriétaire doit être le nouvel utilisateur");
    }
}
