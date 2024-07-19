Together : https://github.com/ESGI-WEB/together

# Groupe

| NOM Prénom        | GitHub                                              |
|-------------------|-----------------------------------------------------|
| DUBUISSON Théo    | [Teyo01](https://github.com/Teyo01)                 |
| LE GLOANNEC Erwan | [Quozul](https://github.com/Quozul)                 |
| MORIN Laurie      | [mlaurie](https://github.com/mlaurie)               |
| WADOUX Nicolas    | [Wadoux-Nicolas](https://github.com/Wadoux-Nicolas) |

# Rôles de l'application

- Admin
- Créateur de groupe
- Créateur d'évènement
- Créateur de sondage
- User

# Fonctionnalités

## Spécifications

| Spécifications fonctionnelles      | Développeur.e.s | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|------------------------------------|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Inscription**                    | Nicolas W       | - Les utilisateurs peuvent s'inscrire en créant un compte avec leur adresse e-mail et un mot de passe.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **Création et gestion de groupes** | Laurie M        | - Les utilisateurs peuvent créer des groupes en spécifiant un nom, une description et en invitant des membres via un code d'invitation. <br>- Les administrateurs de groupe peuvent gérer et modérer le groupe, y compris les publications et les évènements. <br>- Les membres peuvent rejoindre des groupes en utilisant le code d'invitation.                                                                                                                                                                                                                                                                                                                                                                                                                               |
| **Messagerie instantanée**         | Erwan L         | - Les membres des groupes peuvent communiquer via une messagerie instantanée intégrée, permettant des discussions en temps réel entre les membres. <br>- Tous les utilisateurs peuvent réagir aux messages à l'aide de smileys.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Gestion d'évènements**           | Théo D          | - Les utilisateurs d’un groupe peuvent créer des évènements en spécifiant une description, une date, un lieu. <br>- Les évènements sont liés à un groupe et peuvent être liés à un évènement. <br>- Les participants peuvent confirmer leur présence. <br>- Les membres peuvent voir sur une carte la position de l'évènement. <br>- Les utilisateurs peuvent choisir le type d'évènement qu'ils veulent créer, une image d'évènement selon le type choisi sera associée. <br>- Duplication d'évènement pour réutilisation future et duplication automatique pour récurrence d'évènement, que ce soit journalier, hebdomadaire, mensuel ou annuel. On peut avoir accès a la liste des évènements à venir d'un groupe, ou des évènements à venir auquel l'utilisateur participe |
| **Système de sondage**             | Nicolas W       | - Les utilisateurs peuvent créer des sondages pour recueillir des opinions ou des votes sur des sujets spécifiques, tels que la notation à la fin d'un évènement ou le choix d'une option pour une activité future. <br>- Les résultats des sondages sont affichés en temps réel. <br>- Le créateur du sondage, du groupe, ainsi que de l'évènement peuvent le modifier et le clôturer. <br>- Les utilisateurs peuvent créer des sondages associés à un évènement. <br>- Une fois le sondage publié, les membres peuvent ajouter leurs propres propositions (option lors de la création). Tout le monde peut avoir accès aux sondages qui sont clos.                                                                                                                           |
| **Publications**                   | Laurie M        | - Un créateur de l'évènement / groupe peut créer et aussi epingler s'il le veut des publications. <br> - Tous les utilisateurs peuvent voir les publications.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 

## Spécifications de l'administrateur

| Spécifications fonctionnelles             | Développeur.e.s | Description                                                                                                                    |
|-------------------------------------------|-----------------|--------------------------------------------------------------------------------------------------------------------------------|
| **Dashboard**                             | Nicolas W       | - Les administrateurs peuvent avoir accès à un dashboard présentant diverses statistiques sur la vie de l'application.         |
| **Gestion des utilisateurs**              | Nicolas W       | - Les administrateurs peuvent consulter la liste des utilisateurs, les modifiers et les supprimer.                             |
| **Gestion de type d'évènements**          | Nicolas W       | - Les administrateurs peuvent créer, modifier et supprimer les types d'évènements.                                             |
| **Contrôle des paramètres de plateforme** | Nicolas W       | - Les administrateurs peuvent configurer les paramètres globaux de la plateforme, tels que les features activées actuellement. |

# Bonus

| Bonus                                                                         | Développeur.e.s    | Détail                                                                                                                                                                                                                                                                                                                          |
|-------------------------------------------------------------------------------|--------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Servir les fichiers du front-end avec le binaire Golang (go embed)**        | Nicolas W          | - Lors de la mise en production, un build flutter est effectué lors de la génération de l'image docker, qui est servie par le backend GO en static sur l'endpoint /app                                                                                                                                                          |
| **Scalabilité horizontale**                                                   | Erwan L            | - Nous utilisons Scaleway pour la production de notre application. Cela nous permet de scaler notre application automatiquement en fonction de son utilisation, de 0 à x instances selon les limites définies, de changer ces ressources en fonction de pic d'utilisation ou de periodes creuses                                |
| **Interface de consultation des logs et stats de fréquentation et d'erreurs** | Erwan L            | - Un grafana est en place à l'aide de [Scaleway](https://www.scaleway.com/fr/) permettant de faire remonter les logs, les status https, CPU, RAM, et d'autres                                                                                                                                                                   |
| **Intégration de Google Maps et API tierces**                                 | Nicolas W, Théo D  | - Lors de la creation d'un évènement, l'adresse est auto-complétée à l'aide de l'api [Adresse](https://adresse.data.gouv.fr/api-doc/adresse) du gouvernement. Cela nous permet d'avoir la latitude/longitude de l'évènement afin d'afficher sur la page d'un évènement, une carte openstreetmap avec la position de l'évènement |
| **Mise en production DevOps CI/CD**                                           | Erwan L, Nicolas W | - Nous avons des tests unitaires qui sont lancés lors de la création d'une PR, permettant de valider la PR ou de bloquer son déploiement. Lors d'un merge sur la branche main, une image docker est générée et est utilisée par la production.                                                                                  |

# Lien de la production

- [Endpoint API](https://esgitogetherchalleng5y5x4ryy-esgi-together-challenge-back.functions.fnc.fr-par.scw.cloud)
- [Pannel d'administration](https://esgitogetherchalleng5y5x4ryy-esgi-together-challenge-back.functions.fnc.fr-par.scw.cloud/app)
- [Documentation API](https://esgitogetherchalleng5y5x4ryy-esgi-together-challenge-back.functions.fnc.fr-par.scw.cloud/swagger/ui)

# Installation

## Prérequis

- Docker
- Docker-compose
- Flutter

## Installation du backend

- A la racine, copier le .env.example en .env

```bash
cp .env.example .env
```

- Il faut remplir les variables d'environnement dans le fichier .env en ayant un S3 à disposition, sinon il n'est pas
  possible de créer des types d'évènement qui stockent les images sur ce S3

- Lancer les conteneurs docker en étant à la racine du projet

```bash
docker compose up -d
```

- Cela devrait vous créer une base de données migrée et un serveur go
- Se rendre sur http://localhost:8080 pour acceder à l'API une fois que le serveur go est lancé (cela peut prendre
  quelques secondes avant que l'endpoint soit disponible), un Hello World devrait s'afficher

## Installation de l'application mobile

- Aller dans le dossier /front

```bash
cd front
```

- copier le .env.prod en .env et modifier les variable d'environnement API_URL et WEB_SOCKET_URL par l'ip de votre pc sur le port 8080 (
  ipconfig sur windows, ifconfig sur linux)

```bash
cp .env.prod .env
```

Par exemple
```md
API_URL=http://192.123.123.123:8080
WEB_SOCKET_URL=ws://192.123.123.123:8080/ws
```

- Lancer l'application sur votre emulateur ou votre téléphone
- Pour lancer l'app web en parallele sur chrome (ou autre) en mode dev, vous aurez accès au pannel d'administration

```bash
flutter run -d chrome
```

Attention ! Faut pour ca bien mettre l'ip de votre pc dans le fichier .env et non le localhost de l'emulateur (pas
10.0.2.2:8080)

## Swagger

Toutes les routes sont documentées sur swagger, pour y accéder, rendez-vous sur
http://localhost:8080/swagger/ui

- Authentification
    - Pour accéder à certaines routes, il faut être authentifié
    - Pour cela, il faut se rendre sur la route /auth/register pour créer un compte
    - Puis sur la route /auth/login pour se connecter
    - Une fois connecté, vous recevrez un token JWT à mettre dans le header Authorization pour accéder aux routes
      protégées
    - Dans swagger, cliquez sur Authorize en haut à droite, et mettez le token dans le champ Value prefixé par Bearer,
      par exemple : `Bearer eyJhb...`

## Traductions

Les fichiers de traductions sont dans /front/lib/l10n

Lancer cette commande pour regenerer les fichiers de traductions si vous avez une erreur ou si vous n'avez pas de hot reload

```bash
flutter gen-l10n
```

Si vous utilisez le hot reload, tout se fera automatiquement

## Testing

- Lancer les tests du back depuis le conteneur docker :

```bash
docker exec together-app go test -v ./...
```