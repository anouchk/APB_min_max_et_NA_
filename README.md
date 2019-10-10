# APB_min_max_et_NA_

Il s'agit d'appliquer les fonctions fonctions sum, as.numeric ou encore merge de data.table dans R, 
expliquées dans cette <a href="https://github.com/rstudio/cheatsheets/raw/master/datatable.pdf">cheatsheet</a>, 
à un jeu de données du MESRI relatif aux voeux de poursuites d'études et aux admissions des futurs bacheliers en 2017 via APB.

L'objectif est de voir, dans chaque académie, le lycée prépa qui a le plus ou le moins d'admis boursiers (les valeurs extrêmes). 
On a procédé par étapes, en calculant :
- la moyenne du % admis boursiers/candidats par académie dans les classes prépa
- la moyenne du % admis boursiers/candidats par établissement dans les classes prépa
Puis on mêle les deux jeux de données avec merge
Et enfin on regarde les valeurs extrêmes de chaque académie avec la fonction order et avec SD.

Il a fallu en premier lieu convertir les variables qui nous intéressent en numériqueavec as.numeric
On était aussi embêté parce que certaines valeurs sont a 'inconnu' ou '', et R ne peut pas les convertir en nombre. 
Il met des NA, et ça nous convient très bien.
Mais ensuite, il faut utiliser l'astuce na.rm=T qui permet de retirer les NA quand on calcule la somme ou la moyenne.
Si on ne met pas ça, R renvoie des NA partout. Car pour R la somme d'un chiffre et d'un NA, c'est NA par défaut.

