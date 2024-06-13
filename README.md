# Groupe

| NOM Prénom      | GitHub          |
|-----------------|-----------------|
| DUBUISSON Théo  | [Teyo01](https://github.com/Teyo01) |
| LE GLOANNEC Erwan | [Quozul](https://github.com/Quozul) |
| MORIN Laurie    | [mlaurie](https://github.com/mlaurie) |
| WADOUX Nicolas  | [Wadoux-Nicolas](https://github.com/Wadoux-Nicolas) |

# Rôles

- User
- Créateur de groupe
- Créateur d'évènement
- Créateur de sondage
- Admin

# Spécifications

| Spécifications fonctionnelles        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Inscription et profil utilisateur** | - Les utilisateurs peuvent s'inscrire en créant un compte avec leur adresse e-mail et un mot de passe. <br>- Chaque utilisateur a un profil personnalisé où ils peuvent ajouter des informations telles que leur nom, photo de profil et biographie.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **Création et gestion de groupes**   | - Les utilisateurs peuvent créer des groupes en spécifiant un nom, une description et en invitant des membres via un code d'invitation. <br>- Les administrateurs de groupe peuvent gérer et modérer le groupe, y compris les membres, les publications, les évènements, etc. <br>- Les membres peuvent rejoindre des groupes en utilisant le code d'invitation.                                                                                                                                                                                                                                                                                                                  |
| **Messagerie instantanée**           | - Les membres des groupes peuvent communiquer via une messagerie instantanée intégrée, permettant des discussions en temps réel entre les membres. <br>- Les fonctionnalités de notification permettent aux utilisateurs de rester informés des nouvelles activités dans leurs groupes et conversations. <br>- Tous les membres d'un groupe peuvent épingler un message dans la discussion et voir ce message. <br> - Tous les utilisateurs peuvent réagir aux messages                                                                                                                                                                                                           |
| **Gestion d'évènements**             | - Les utilisateurs d’un groupe peuvent créer des évènements en spécifiant une description, une date (optionnel), un lieu (optionnel) et une liste de choses à amener, telles que des plats pour un buffet ou une contribution financière. <br>- Les évènements sont liés à un groupe. <br>- Les participants peuvent confirmer leur présence à condition que les sondages associés à l’évènement soient clos. <br> - Les membres peuvent voir sur une carte la position de l'évènement si la géolocalisation existe. <br>- Les utilisateurs peuvent choisir le type d'évènement qu'ils veulent créer, un icone s'affiche.<br>- Duplication d'évènement pour réutilisation future. |
| **Système de sondage**               | - Les utilisateurs peuvent créer des sondages pour recueillir des opinions ou des votes sur des sujets spécifiques, tels que la notation à la fin d'un évènement ou le choix d'une option pour une activité future. <br>- Les résultats des sondages sont affichés en temps réel. <br>- Le créateur du sondage peut le clôturer. <br>- Les utilisateurs peuvent créer des sondages associés à un évènement. <br>- Duplication de sondage pour réutilisation future. <br>- Une fois le sondage publié, les membres peuvent ajouter leurs propres propositions (option lors de la création).                                                                                        |
| **Évènements récurrents** | - Les utilisateurs ont la possibilité de créer des évènements récurrents.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **Publications**                     | - Un créateur de l'évènement / groupe peut publier (et aussi epingler s'il le veut) des publications (type de message). <br> - Tous les utilisateurs peuvent voir les messages. <br> - Tous les utilisateurs peuvent réagir aux messages.                                                                                                                                                                                                                                                                                                                                                                                                                                         | 

# Spécifications de l'administrateur

| Spécifications fonctionnelles             | Description                                                                                                                    |
|-------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| **Gestion des utilisateurs**              | - Les administrateurs peuvent consulter la liste des utilisateurs, les modifiers et les supprimer.                             |
| **Gestion des groupes & évènements**      | - Les administrateurs peuvent créer, supprimer et gérer des groupes/évènements/sondages sur la plateforme.<br> - Les administrateurs peuvent ajouter des types d'évènements.                     |
| **Contrôle des paramètres de plateforme** | - Les administrateurs peuvent configurer les paramètres globaux de la plateforme, tels que les features activées actuellement. |

# Scénario
### Scénario 1 :

1. Je crée un évènement “C’est mon anniversaire !” le 1 juillet à Paris.
2. Je crée un sondage lié à mon évènement “Quelle activité avez-vous envie de faire ?” avec plusieurs choix possibles, et ouvert à de nouvelles propositions :
    - “Bar”
    - “Karting”
    - “Karaoké”
3. Je crée un deuxième sondage “A quelle heure êtes-vous disponibles” (fermé à de nouvelles propositions) :
    - “19h”
    - “20h”
    - “21h”
4. Les autres membres peuvent répondre au sondage.
5. Je clôture le sondage.
6. Les autres membres indiquent s’ils participent ou non à l’évènement.

### Scénario 2 :

1. Je crée un sondage “Quel genre de pâte aimez-vous ?” avec plusieurs choix possibles (fermé à de nouvelles propositions) :
    - “coquillettes”
    - “tagliatelle”
2. Les autres membres peuvent répondre au sondage.

### Scénario 3 :

1. Je crée un évènement “Sortir au Louvre” ce weekend à 16h.
2. Les autres membres indiquent s’ils participent ou non à l’évènement.


# Installation

## GO

- Soyez sur d'avoir téléchargé Gow, qui permet d'avoir une sorte de nodemon pour Go
```bash
go install github.com/mitranim/gow@latest
```
- N'oubliez pas de redémarrer votre terminal pour que les changements soient pris en compte

- Aller dans le dossier /back
```bash
cd back
```

- Lancer les conteneurs docker
```bash
docker compose up -d
```

- Se rendre sur http://localhost:8080 pour acceder à l'API une fois que le serveur go est lancé (peut prendre quelques secondes)

## Swagger
Toutes les routes sont documentées sur swagger, pour y accéder, rendez-vous sur
http://localhost:8080/swagger/ui

- Authentification
    - Pour accéder à certaines routes, il faut être authentifié
    - Pour cela, il faut se rendre sur la route /auth/register pour créer un compte
    - Puis sur la route /auth/login pour se connecter
    - Une fois connecté, vous recevrez un token JWT à mettre dans le header Authorization pour accéder aux routes protégées
    - Dans swagger, cliquez sur Authorize en haut à droite, et mettez le token dans le champ Value prefixé par Bearer, par exemple : `Bearer eyJhb...`

## Flutter
- Aller dans le dossier /front
```bash
cd front
```

- copier le .env.prod en .env et modifier la variable d'environnement API_URL par l'ip de votre pc sur le port 8080 (ipconfig sur windows, ifconfig sur linux)
```bash
cp .env.prod .env
```
Quelque chose comme 192.123.123.123:8080

- Lancer l'application sur votre emulateur ou votre téléphone
- Pour lancer l'app web en parallele sur chrome (ou autre) en mode dev
```bash
flutter run -d chrome
```
Attention ! Faut pour ca bien mettre l'ip de votre pc dans le fichier .env et non le localhost de l'emulateur (pas 10.0.2.2:8080)
