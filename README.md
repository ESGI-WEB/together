# Groupe

| NOM Prénom      | GitHub          |
|-----------------|-----------------|
| DUBUISSON Théo  | [Teyo01](https://github.com/Teyo01) |
| LE GLOANNEC Erwan | [Quozul](https://github.com/Quozul) |
| MORIN Laurie    | [mlaurie](https://github.com/mlaurie) |
| WADOUX Nicolas  | [Wadoux-Nicolas](https://github.com/Wadoux-Nicolas) |

# Specifications

| Spécifications fonctionnelles            | Description |
|------------------------------------------|-------------|
| **Inscription et Profil Utilisateur**    | - Les utilisateurs peuvent s'inscrire en créant un compte avec leur adresse e-mail et un mot de passe. <br>- Chaque utilisateur a un profil personnalisé où ils peuvent ajouter des informations telles que leur nom, photo de profil et biographie. |
| **Création et Gestion de Groupes**       | - Les utilisateurs peuvent créer des groupes en spécifiant un nom, une description et en invitant des membres via un code d'invitation. <br>- Les administrateurs de groupe peuvent gérer et modérer le groupe, y compris les membres, les publications, les évènements, etc. <br>- Les membres peuvent rejoindre des groupes en utilisant le code d'invitation. |
| **Messagerie Instantanée**               | - Les membres des groupes peuvent communiquer via une messagerie instantanée intégrée, permettant des discussions en temps réel entre les membres. <br>- Les fonctionnalités de notification permettent aux utilisateurs de rester informés des nouvelles activités dans leurs groupes et conversations. |
| **Gestion d'évènements**                 | - Les utilisateurs d’un groupe peuvent créer des évènements en spécifiant une description, une date (optionnel), un lieu (optionnel) et une liste de choses à amener, telles que des plats pour un buffet ou une contribution financière. <br>- Les évènements sont liés à un groupe. <br>- Les participants peuvent confirmer leur présence à condition que les sondages associés à l’évènement soient clos. <br>- Les participants peuvent commenter l'évènement et voir qui d'autre y participe. |
| **Système de Sondage isolés**            | - Les utilisateurs peuvent créer des sondages pour recueillir des opinions ou des votes sur des sujets spécifiques, tels que la notation à la fin d'un évènement ou le choix d'une option pour une activité future. <br>- Les résultats des sondages sont affichés en temps réel. <br>- Le créateur du sondage peut le clôturer. <br>- Les utilisateurs peuvent créer des sondages associés à un évènement. <br>- Duplication de sondage pour réutilisation future. <br>- Une fois le sondage publié, les membres peuvent ajouter leurs propres propositions (option lors de la création). |
| **Évènements Récurrents et Duplication** | - Les utilisateurs ont la possibilité de créer des évènements récurrents. |

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
