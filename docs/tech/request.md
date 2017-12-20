Comme il s'agit d'une application client-serveur, tout est asynchrone. Cette fiche brosse l'ensemble des aspects réseaux de l'application et présente les classes et objets qui entrent en jeux.


 * Toutes les requêtes du client sont exécuté par le `NetworkManager` via l'objet `Request`;
 * Toutes les resources du model (`Sample`, `File`, `Subject`, `Project`, ...) vont suivre un même cycle de vie;
 * Certaines resources un peu plus compliquées comme les `FilteringAnalysis` vont avoir un cycle un peu plus compliquée aussi.


## Request


## NetworkManager


## Websocket


## HTTP / HTTPS


## Connection status

En fonction des aléas du réseau, il faut être en mesure de présenter à tout instant un status clair de la situation à l'utilisateur. Le client doit donc gérer finement le status de la connection et savoir si des données sont présentable ou non, en cours de synchronisation ou pas, etc. Et en cas d'interruption, il faut recharger certains élément afin d'être à jours.

TODO: diag flow + machine a état du status

## 