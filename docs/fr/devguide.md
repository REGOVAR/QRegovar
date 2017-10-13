# Developer Guide



## Compiler QT
Pour que Qt puisse utiliser correctement certaine librairie, comme openSSL, il peut être nécessaire de compiler soit-même QT.
### Linux :
* Télécharger la dernière version des [sources](https://www1.qt.io/download-open-source/?hsCtaTracking=f977210e-de67-475f-a32b-65cec207fd03%7Cd62710cd-e1db-46aa-8d4d-2f1c1ffdacea#section-2) de Qt;
* Déziper le fichier en aller dans le répertoire;
* `./configure -debug -opensource -ssl -openssl-linked -proprietary-codecs -printing-and-pdf`;
* `make -j 7`;
* 





