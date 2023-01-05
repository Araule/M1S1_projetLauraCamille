#!/usr/bin/env bash

###################################################
#
# Ce fichier bash est à utiliser directement dans
# le dossier itrameur.
#
###################################################


fichier_raw=$1
fichier_tokenized=$2
fichier_final=$3


# d'abord on tokenise le fichier
python3 ./tokenize_chinese.py $fichier_raw > ./fichier_1.txt
sed "s/看\s书/看书/g" ./fichier_1.txt > ./fichier_2.txt # on recolle le verbe lire "看书"
sed "s/[a-zA-Z0-9()&#*<>=§/_%.\"-]*//g" ./fichier_2.txt > $fichier_tokenized # on enlève quelques caractères inutiles

# on supprime les fichiers inutiles
rm ./fichier_*.txt

# ensuite on enlève les mots vides et on les dump dans un fichier final
touch $fichier_final
echo -e "\nvous pouvez passer à la dernière partie en copiant la ligne de commande suivante"
echo -e "\tpython3 ./stopword.py"