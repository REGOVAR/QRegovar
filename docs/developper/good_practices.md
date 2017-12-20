
## Github et les tickets
###Création ticket
 * De préférence, rédiger les tickets en anglais;
 * Être le plus précis possible sur le problème rencontré, et notament sur comment le reproduire;
 * Laisser les membres du projet (sur github) attribuer les labels, millestones et assignation qu'il convient;

###Travailler à plusieurs
 * Projet libre et open-source. C'est donc aux développeur de s'assigner eux-même les tickets sur lesquels ils souhaitent travailler;
 * On évite de travailler à plusieurs sur un même ticket afin de limiter les problèmes lors des commits. 
 * Chaque développeur doit se créer sa propre branche (avec pour nom par exemple "MonPseudo-dev") pour travailler. Il pourra ensuite merger avec la branche principale quand il aura terminé;
 * Chaque commit doit avoir un commentaire en anglais (et de préférence utile...).

###Les branches
 * La branche `master` correspond toujours à la dernière version utilisable du serveur;
 * Quand une version stable est officialisé, on la tag avec son numéro de version officiel;
 * Les développeurs doivent travailler sur leur propre branche et merger avec master seulement quand ils ont terminés.

###Milestones
 * Attentions, les milestones sont les échéance officieles de Regovar, merci de laisser [Oodnadatta](https://github.com/Oodnadatta) ou [Ikit](https://github.com/ikit) s'en occuper;
 * La prochaine milestone et sa progression sont visible par tout le monde directement via le client officiel [QRegovar](https://github.com/REGOVAR/QRegovar).


## Documentation
 * Il est important de bien documenter le code. Chaque fonction et chaque classe doit avoir un commentaire en-tête (python : entre triple """) (C++ avec commentaire //! ou /\*! \*/);
 * Penser aussi à mettre à jour la documentation en ligne une fois que vous avez terminé ce que vous avez commencé. Merci de faire attention à respecter l'organisation et la mise en forme utilisé pour ReadTheDoc;
 * Ne pas hésiter à mettre un ticket GitHub pour ne pas oublier de faire la traduction dans les autres langues si vous ne le faites pas.
 * Si vous créez de nouvelles erreurs, se référer à la documentation (ci-dessous) pour y associer un code et intégrer correctement ces erreurs dans le système mis en place.
 
 
## Traduction
Tout le code et les messages du serveur doivent être rédigés en anglais. La traduction se fait uniquement côté client grâce notament aux outils proposés par le framework Qt.


## Tests
###Tests Unitaires
 * Pour lancer les TU, il suffit de lancer la commande `make test`;
 * Le code source des tests se trouvent dans le répertoire `regovar/tests`
 * Les fichiers d'inputs utilisés pour les tests se trouvent dans `regovar/tests/inputs`
 * Les tests doivent couvrir à minima:
     * L'ensemble des opérations de base (CRUD) du model;
     * Les fonctionnalités des managers du core;
 * A noter que lorsqu'on lance les tests via le makefile, une nouvelle base de donnée est créée afin de ne pas polluer ou corompre la base de donnée utilisé par le développeur.


###Coverage
Nous utilisons le module python `coverage` pour calculer la couverture des tests et générer le rapport au format xml, ensuite on envoie ces données à l'outils `codacy` qui permet de centraliser et de publier l'information via github.

```
pip install coverage
pip install codacy-coverage
coverage run tests.py
coverage xml
export CODACY_PROJECT_TOKEN={token codacy du projet Regovar}
python-codacy-coverage -r coverage.xml
```


###Travis
Nous utilisons travis qui s'occupe de tester que tout fonctionne correctement après chaque commit sur la branche `master`. Après avoir construit une machine virtuelle répondant aux besoins de Regovar, il exécute pour nous les TU ainsi que la génération du rapport de couverture.




## Gestion des erreurs
###Outils du Core
 * Vous trouverez dans `regovar/core/framework/common.py` les outils de base:
     * Les logs avec les 3 methodes pour chaque niveau d'alertes : `log`, `war` et `err` (accepte les exceptions en argument);
     * Les logs volumineux avec la méthode `log_snippet`
     * La classe RegovarException qui se chargera automatiquement d'écrire les log.
 * Erreurs gérées:
     * Liste des erreur associées à leur code dans le fichier : `regovar/core/framework/errors_list.py`;
     * Associer une erreur à un code permet ensuite de remonter et fournir ce code à l'utilisateur non technique qui pourra demander du support ou trouver la doc en ligne concernant cette erreur;
     * Il faut pour cela lever une exception de type `RegovarException` en indiquant en paramètre le code d'erreur;
     * Penser à tenir à jour le fichier `regovar/core/framework/errors_list.py` ainsi que les fiches d'aide correspondant à chaque erreur dans le répertoire `regovar/api_rest/templates/errors/`.

###Outils de l'api Rest
 * Dans le fichier `regovar/api_rest/rest.py`;
 * Les methode `rest_error` ou `rest_exception` doivent être systématiquement utilisés pour remonter une erreur aux clients;
 * Ces deux methodes se chargement de formater correctement la réponse json en cas d'échec.


## Convention de codage
###Nomenclature et règles de codage
Pour ceux qui connaissent, nous respectons la convention Python [PEP8](https://www.python.org/dev/peps/pep-0008/). Pour ceux qui ont la flemme de tout lire, au moins lire [le résumé par Sam&Max](http://sametmax.com/le-pep8-en-resume/)
Cependant, nous tolérons les entorses suivantes :

 * sauter plusieurs ligne entre définition de class ou de fonction car ça permet d'avoir un code plus aéré;
 * avoir des lignes de code faisant plus de 80 caractères.

###Organisation du code
L'organisation du code est normalement suffisament simple et propre pour qu'on puisse facilement s'y repérer. En cas de doute, merci de demander à l'équipe du projet. Pour plus de détails, il est recommandé de lire l'ensemble des documents de la section *DEVELOPPEUR*.
