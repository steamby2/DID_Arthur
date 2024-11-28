# README - DID Management Project

## Description
Ce projet vise à développer une application permettant la gestion des Identifiants Décentralisés (DIDs) grâce à un smart contract déployé sur la blockchain Ethereum. L'application utilise React pour l'interface utilisateur et Web3 pour interagir avec le contrat intelligent.

## Objectifs
- Créer, mettre à jour et vérifier des DIDs.
- Implémenter une gestion des rôles au sein de l’écosystème.
- Développer une interface utilisateur intuitive pour interagir avec la blockchain.

## Technologies utilisées
- **Smart contract :** Développé avec Solidity et OpenZeppelin sur Remix.
- **Blockchain :** Ethereum (Testnet Sepolia).
- **Frontend :** React.js.
- **Interaction blockchain :** Web3.js.

## Fonctionnalités
- Création et mise à jour des DIDs.
- Vérification des DIDs avec des rôles spécifiques.
- Contrôle des accès via une interface React connectée au smart contract.

## Prérequis
- Node.js (v16+)
- Wallet compatible Ethereum (ex. MetaMask)
- Accès au réseau de test Sepolia
- Clé API pour interagir avec Etherscan (optionnel)

## Installation
1. **Cloner le projet** :
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```
2. **Installer les dépendances** :
   ```bash
   npm install
   ```
3. **Lancer l’application** :
   ```bash
   npm start
   ```

## Déploiement du contrat
1. Développez et testez le contrat sur Remix.
2. Déployez le contrat sur le testnet Sepolia avec votre wallet.
3. Configurez l’adresse du contrat dans l’application React.

## Utilisation
1. Ouvrez l’application dans un navigateur.
2. Connectez votre wallet.
3. Interagissez avec le contrat pour gérer les DIDs (création, mise à jour, vérification).

## Auteur
Arthur Cayuso

## Licence
Ce projet est sous licence MIT. Vous êtes libre de l’utiliser, de le modifier et de le distribuer.
